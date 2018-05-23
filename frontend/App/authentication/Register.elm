module Register exposing (view, update, init, subscriptions, Model)

import Html exposing (div, Html, text)

-- MESSAGE --
type Msg
  = Submit


-- MODEL --
type Error
  = PasswordTooShort
  | PasswordsDontMatch
  | UsernameExists

type alias Credentials =
  { name : String
  , password : String
  , rPassword : String
  }

type alias Model =
  { credentials : Credentials
  , errors : List Error
  , attempts : Int
  }


-- INIT --
init : (Model, Cmd msg)
init =
  (Model (Credentials "" "" "") [] 0, Cmd.none)

-- VIEW --
view : Model -> Html msg
view model =
  div [] [ text "hello" ]


-- UPDATE --
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Submit ->
      (model, Cmd.none)

-- SUBSCRIPTIONS --
subscriptions : Sub msg
subscriptions =
  Sub.none
