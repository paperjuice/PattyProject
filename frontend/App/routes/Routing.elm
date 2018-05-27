module Routing exposing (Route(..), Model, parseLocation)

import UrlParser exposing (Parser, oneOf, map, (</>),s ,top, parseHash, string)
import Navigation exposing (Location)


type Route
  = Home
  | Login
  | Register
  | Cleaner
  | Reception
  | Admin
  | AdminRoom String
  | RouteNotFound


type alias Model =
  { route : Route
  }

-- PARSE ROUTE --
parseLocation : Location -> Route
parseLocation location =
  case (parseHash matcher location) of
    Just route -> route
    Nothing    -> RouteNotFound

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

