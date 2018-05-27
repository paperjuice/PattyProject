module Home exposing (..)

import Html exposing (div, Html, text, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)


-- MSG --
type Msg
  = Hello

-- MODEL --
type alias Model =
  { }

view : Model -> Html Msg
view model =
  div []
      [ div [ class "background" ] []
      , div [ class "icon" ] []
      , div [ class "login" ]
            [ button [ onClick Hello ][ text "Login" ]
            ]
      , div [ class "register" ] []
      ]

