module Home exposing (..)

import Html exposing (div, Html, text, button, img)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, src)


hotel_svg = 
  "https://cdn3.iconfinder.com/data/icons/buildings-places/512/Hotels_B-512.png"
-- MSG --
type Msg
  = Hello

-- MODEL --
type alias Model =
  { }

view : Model -> Html msg
view model =
  div []
      [ div [ class "background" ] []
      , div [] [ img [ class "icon", src hotel_svg] []]
      , div [] [ button [ class "login" ][ text "Login" ] ]
      , div [] [ button [ class "register" ][ text "Register" ] ]
      ]

