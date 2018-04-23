import Html exposing (Html, h1, img, span, div, text, button)
import Html.Attributes exposing (class, src, style)
import Html.Events exposing (onClick)

main =
  Html.beginnerProgram
  { model = model
  , view = view
  , update = update
  }

image_url =
  "https://raw.githubusercontent.com/b00giZm/b00gizm.github.io/master/uploads/elm-logo.png"

-- MESSAGE --

type Msg
  = Activate Int
  | Confirm Int

-- MODEL --

type State
  = Busy
  | Dirty
  | InProgress
  | Clean

type alias Room =
  { id : Int
  , state : State
  , active : Bool
  }

type alias Model =
  { rooms : List Room
  , activeRoomId : Int
  }

model : Model
model =
  { activeRoomId = 0
  , rooms =
    [ { id = 101
      , state = Dirty
      , active = False
      }
      ,
      { id = 102
      , state = Busy
      , active = False
      }
      ,
      { id = 103
      , state = Clean
      , active = False
      }
      ,
      { id = 103
      , state = InProgress
      , active = False
      }
      ,
      { id = 104
      , state = InProgress
      , active = False
      }
      ,
      { id = 105
      , state = Busy
      , active = False
      }
      ,
      { id = 106
      , state = Busy
      , active = False
      }
      ,
      { id = 107
      , state = Busy
      , active = False
      }
      ,
      { id = 108
      , state = Busy
      , active = False
      }
      ,
      { id = 109
      , state = Dirty
      , active = False
      }
      ,
      { id = 110
      , state = Busy
      , active = False
      }
      ,
      { id = 111
      , state = Clean
      , active = False
      }
      ,
      { id = 112
      , state = InProgress
      , active = False
      }
      ,
      { id = 113
      , state = InProgress
      , active = False
      }
      ,
      { id = 114
      , state = Busy
      , active = False
      }
      ,
      { id = 115
      , state = Busy
      , active = False
      }
      ,
      { id = 116
      , state = Busy
      , active = False
      }
      ,
      { id = 117
      , state = Busy
      , active = False
      }
    ]
  }


-- VIEW --

view : Model -> Html Msg
view model =
  div [ class "body" ]
    [ renderFloorPanel
    , div [ class "roomContainer" ]
       (List.map (\room-> (renderDoors room.id room.state)) model.rooms)
    , confirmRoom model
    , div[] [ text(toString model.activeRoomId)]
    ]

confirmRoom : Model -> Html msg
confirmRoom model =
  case model.activeRoomId of
    0      -> div[][]

    roomId ->
      let
          my_room =
            model.rooms
            |> List.filter(\room -> room.id == model.activeRoomId)
            |> List.head
      in
          case my_room of
            Nothing   -> div [] []
            Just room -> confirmPanel room


confirmPanel : Room -> Html msg
confirmPanel room =
  case room.state of
    _ ->
      div [ class "confirmPanel"]
        [ h1 [] [ text ("Incepe curatarea camerei " ++ (toString room.id)) ]
        , button [ class "Yes" ] [ text "Da" ]
        , button [ class "No" ] [ text "Nu" ]
        ]

    --  _ ->
    --    div [] []


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

update : Msg -> Model -> Model
update msg model =
  case msg of
    Activate roomId->
      { model | activeRoomId = roomId }

    Confirm roomId ->
      model

