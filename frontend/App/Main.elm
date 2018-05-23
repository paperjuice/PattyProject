import Html exposing (div, text, Html)
import Navigation exposing (Location)
import UrlParser exposing (Parser, oneOf, map, (</>),s ,top, parseHash, string)

-- MAIN --
main =
  Navigation.program Route
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- TYPES --
type Route
  = Home
  | Login
  | Register
  | Cleaner
  | Reception
  | Admin
  | AdminRoom String
  | RouteNotFound

type Msg
  = Route Navigation.Location

type alias Model =
  { route : Route
  }

-- INIT --
init : Location -> (Model, Cmd msg)
init location =
  update (Route location) (Model Home)


-- PARSE ROUTE --
matcher : Parser (Route -> a) a
matcher =
  oneOf
  [ map Home top
  , map Login (s "login")
  , map Register (s "register")
  , map Cleaner (s "cleaner")
  , map Reception (s "reception")
  , map Admin (s "admin")
  , map AdminRoom (s "admin" </> string)
  ]

parseLocation : Location -> Route
parseLocation location =
  case (parseHash matcher location) of
    Just route -> route
    Nothing    -> RouteNotFound


-- VIEW --
view : Model -> Html msg
view model =
  case model.route of
    Home -> div [] [ text "Home" ]
    _    -> div [] [ text "Else" ]


-- UPDATE --
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Route location ->
      let
          route = parseLocation location
            |> Debug.log "location"
      in
          ({ model | route = route }, Cmd.none)

-- SUBSCRIPTIONS --
subscriptions : Model -> Sub msg
subscriptions model =
  Sub.none
