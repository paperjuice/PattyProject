import Routing
import Home
import Html exposing (div, text, Html)

import Navigation exposing (Location)


-- MAIN --
main =
  Navigation.program Route
  { init = init
  , view = view
  , update = update
  , subscriptions = (\_-> Sub.none)
  }

-- MSG --
type Msg
  = Route Navigation.Location


-- INIT --
init : Location -> (Routing.Model, Cmd msg)
init location =
  update (Route location) (Routing.Model Routing.Home)


-- UPDATE --
update : Msg -> Routing.Model -> (Routing.Model, Cmd msg)
update msg model =
  case msg of


-- VIEW --
view : Routing.Model -> Html msg
view model =
  case model.route of

-- SUBSCRIPTIONS --
--subscriptions : Routing.Model -> Sub msg
--subscriptions model =
--  Sub.none
