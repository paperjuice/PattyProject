import Html exposing (div, text, Html, button)
import Html.Attributes exposing (class)

import Navigation exposing (Location)
import UrlParser exposing (Parser, oneOf, (</>), map, string, s, top, parseHash, int)


-- MAIN --
main =
  Navigation.program Route
  { init = init
  , view = view
  , update = update
  , subscriptions = (\_-> Sub.none)
  }

-- MODEL --
type alias Model =
  { route : Route
    }

-- ROUTING --
type Route
  = Home
  | Login
  | Register
  | Admin
  | AdminRoom String
  | Cleaner Int
  | Reception
  | RouteNotFound

matchLocation : Location -> Route
matchLocation location =
  case (parseHash matcher location) of
    Just route -> route
    Nothing    -> RouteNotFound


matcher : Parser ( Route -> a ) a
matcher =
  oneOf
  [ map Home top
  , map Login (s "login")
  , map Register (s "register")
  , map Admin (s "admin")
  , map AdminRoom (s "admin" </> string)
  , map Cleaner (s "cleaner" </> int)
  , map Reception (s "reception")
  ]

-- MSG --
type Msg
  = Route Navigation.Location


-- INIT --
init : Location -> (Model, Cmd msg)
init location =
  update (Route location) (Model Home)


-- UPDATE --
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Route location ->
      let
          newRoute = matchLocation location
      in
          ({model | route = newRoute}, Cmd.none )


-- VIEW --
view : Model -> Html msg
view model =
  case model.route of
    Home                 -> homeView model
    Register             -> div [] [ text "Register" ]
    Login                -> div [] [ text "Login" ]
    Admin                -> div [] [ text "Here you can add new workers" ]
    AdminRoom roomNumber -> div [] [ text "Here you see the room status, probabil ca ar trebui sa poti sa vezi toate camerele, donno" ]
    Cleaner floorNumber  -> div [] [ text "Cleaner view based on floor" ]
    Reception            -> div [] [ text "Reception where it can see all the floors/rooms" ]
    RouteNotFound        -> div [] [ text "The path doesn't exist :(" ]


----------------------
--- VIEW HOME --------
----------------------
homeView : Model -> Html msg
homeView model =
  div [ ]
      [ div [ class "icon" ] [ text "Here insert icon" ]
      , div [ class "buttons" ]
            [ button [ class "login" onClick Login ] [ text "Login" ]
            , button [ class "register" onClick Register ] [ text "Register" ]
            ]
      ]


-- SUBSCRIPTIONS --
--subscriptions : Routing.Model -> Sub msg
--subscriptions model =
--  Sub.none
