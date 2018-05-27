module Admin exposing (..)

import Html exposing (Html, h1, img, span, div, text, p, button)
import Html.Attributes exposing (class, src, style)
import Html.Events exposing (onClick)
import Debug exposing (log)
import Json.Decode as JD
import Json.Encode as JE
import WebSocket as WS
import Register

main : Program Never Model Msg
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- VARIABLES --
serverUrl =
  "ws://localhost:9999/roomCleaner"

-- MESSAGE --
type Msg
  = Activate Int
  | Confirm Int
  | NewMessage String
  | CleanerView
  | ReceptionView

-- MODEL --
type State
  = Busy
  | Dirty
  | InProgress
  | Clean

type alias Room =
  { number : Int
  , state : State
  }

type ViewType
  = Cleaner
  | Reception
  | Initial

type alias Model =
  { rooms : List Room
  , activeRoomId : Int
  , viewType : ViewType
  }

init : (Model, Cmd msg)
init =
  (Model [] 0 Initial, WS.send serverUrl ( JE.encode 0 (clientMessage "init" "")))

-- DECODE JSON --
type alias ServerMessage =
  { msg_type : String
  , msg : List Room
  }

type alias MessageType =
  { msg_type : String}

messageTypeDecode =
  JD.map MessageType
  (JD.field "msg_type" JD.string)

msgDecoder : JD.Decoder ServerMessage
msgDecoder =
  JD.map2 ServerMessage
    (JD.field "msg_type" JD.string)
    (JD.field "msg" roomsDecoder)

roomDecode=
  JD.map2 Room
  ( JD.field "number" JD.int)
  ( JD.field "state" JD.string
    |> JD.andThen stateDecoder
  )

roomsDecoder =
  JD.list roomDecoder

roomDecoder : JD.Decoder Room
roomDecoder =
  JD.map2 Room
    (JD.field "number" JD.int)
    (JD.field "state" JD.string
      |> JD.andThen stateDecoder
    )

stateDecoder : String -> JD.Decoder State
stateDecoder state =
  case state of
    "dirty"       -> JD.succeed Dirty
    "busy"        -> JD.succeed Busy
    "in_progress" -> JD.succeed InProgress
    "clean"       -> JD.succeed Clean
    error         -> JD.fail <| "It failed for the following reason" ++ error

-- ENCODE JSON --
clientMessage : String -> String -> JE.Value
clientMessage msg_type msg =
  JE.object
  [ ("msg_type", JE.string msg_type)
  , ("msg", JE.string msg)
  ]

updateRoom number state =
  JE.object
  [ ("msg_type", JE.string "update_room")
  , ("number", JE.int number)
  , ("state", JE.string (defineState state))
  ]
defineState state =
  case state of
    Clean -> "clean"
    Dirty -> "dirty"
    InProgress -> "in_progress"
    Busy -> "busy"


-- VIEW --
view : Model -> Html Msg
view model =
  case model.viewType of
    Initial   -> viewInitial model
    Cleaner   -> viewCleaner model
    Reception -> viewReception model

viewInitial : Model -> Html Msg
viewInitial model =
  div [ ]
      [ button [ onClick CleanerView ] [ text "Cleaner" ]
      , button [ onClick ReceptionView ] [ text "Reception" ]
      ]

viewCleaner : Model -> Html Msg
viewCleaner model =
  div [ class "body" ]
    [ renderFloorPanel
    , div [ class "roomContainer" ]
       (List.map (\room-> (renderDoors room.number room.state)) model.rooms)
    , confirmRoom model
    , div[] [ text(toString model.activeRoomId)]
    ]

viewReception : Model -> Html msg
viewReception model =
  div [] [ text "Reception" ]


confirmRoom : Model -> Html Msg
confirmRoom model =
  case model.activeRoomId of
    0      -> div[][]

    roomId ->
      let
          my_room =
            model.rooms
            |> List.filter(\room -> room.number == model.activeRoomId)
            |> List.head
      in
          case my_room of
            Nothing   -> div [] []
            Just room -> confirmPanel room


confirmPanel : Room -> Html Msg
confirmPanel room =
  case room.state of
    Dirty ->
      confirmPanelHtml room "Incepe curatarea camerei"

    InProgress ->
      confirmPanelHtml room "A fost efectuata curatarea camerei"
    _ -> div [] []

confirmPanelHtml : Room -> String -> Html Msg
confirmPanelHtml room message =
  div [ class "confirmPanel"]
    [ h1 [] [ text (message ++ " " ++ (toString room.number) ++ "?") ]
    , button [ class "yes", onClick (Confirm room.number) ]
      [ p [] [ text "Da"] ]
    , button [ class "no" , onClick (Confirm 0) ]
      [ p [] [ text "Nu"] ]
    ]

renderFloorPanel =
  div [ class "floorPanel" ]
    [ div [ class "floor" ] [ text "Floor 3" ]
    , div [ class "worker" ] [ text "Manadarine Cusosdenuci" ]
    ]

renderDoors : Int -> State -> Html Msg
renderDoors roomId state =
  div [ class "room" ]
    [ div [class "text"] [text (roomId |> toString)]
    , div [ class "doorImage", onClick (Activate roomId) ] [img [ src(getDoorOnStatus state ) ] [] ]
    ]

getDoorOnStatus : State -> String
getDoorOnStatus state =
  case state of
    Busy ->
      "/priv/doors/busy_1.svg"

    Dirty ->
      "/priv/doors/dirty_1.svg"

    InProgress ->
      "/priv/doors/inProgress_1.svg"

    Clean ->
      "/priv/doors/clean_1.svg"


-- UPDATE --

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    CleanerView ->
      ({model | viewType = Cleaner}, Cmd.none)
    ReceptionView ->
      ({model | viewType = Reception}, Cmd.none)

    Activate roomId->
      ({ model | activeRoomId = roomId }, Cmd.none)

    Confirm 0 ->
      ({ model | activeRoomId = 0 }, Cmd.none)

    Confirm roomId ->
      ({ model
        | rooms =
          List.map(\room ->
            {room | state =
              if room.number == model.activeRoomId then
                (calculateState room.state)
              else
                room.state
            }) model.rooms
        , activeRoomId = 0
      }
      , WS.send serverUrl (JE.encode 0 (updateRoom roomId (calculateState (getRoomByNumber model.rooms roomId).state)))
      )

    NewMessage message ->
      let
          response =
          case JD.decodeString messageTypeDecode message of
            Ok response ->
             case response.msg_type of
               "init_state" -> decodeInitState message
               error -> ServerMessage error []

            _ -> ServerMessage "error" []
      in
      ({model | rooms = response.msg }, Cmd.none)


decodeInitState message =
  case JD.decodeString msgDecoder message of
    Ok response -> response
    _ -> ServerMessage "error" []

getRoomByNumber : List Room -> Int -> Room
getRoomByNumber rooms roomNumber =
  let
      list_of_rooms =
        List.filter(\room ->
          room.number == roomNumber
          ) rooms

      my_room =
        case List.head list_of_rooms of
          Just room -> room
          -- TODO: vezi ca aici daca se f e nasol
          Nothing -> Room 0 Clean
  in
      my_room


calculateState : State -> State
calculateState state =
  case state of
    Dirty -> InProgress
    InProgress -> Clean
    _ -> state



-- SUBSCRIPTIONS --
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ WS.listen serverUrl NewMessage
  ]
