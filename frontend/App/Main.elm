import Html exposing (div, text, Html, button, input)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)

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

-- MSG --
type Msg
  = Route Navigation.Location
  | LoginPage
  | RegisterPage
  | SubmitRegisterRequest
  | InputName String
  | InputHotelName String
  | InputPassword String
  | InputRPassword String


-- MODEL --
type CredentialError
  = PasswordsDontMatch
  | PasswordTooShort

type alias RegisterData =
  { name      : String
  , hotelName : String
  , password  : String
  , rPassword : String
  }

type alias Model =
  { route : Route
  , credentialCheck : List CredentialError
  , registerData : RegisterData
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
  [ map Home      top
  , map Login     (s "login")
  , map Register  (s "register")
  , map Admin     (s "admin")
  , map AdminRoom (s "admin" </> string)
  , map Cleaner   (s "cleaner" </> int)
  , map Reception (s "reception")
  ]


-- INIT --
init : Location -> (Model, Cmd msg)
init location =
  update (Route location) (Model Home [] (RegisterData "" "" "" ""))


-- VIEW --
view : Model -> Html Msg
view model =
  case model.route of
    Home                 -> viewHome model
    Register             -> viewRegister model
    Login                -> viewLogin model
    Admin                -> div [] [ text "Here you can add new workers" ]
    AdminRoom roomNumber -> div [] [ text "Here you see the room status, probabil ca ar trebui sa poti sa vezi toate camerele, donno" ]
    Cleaner floorNumber  -> div [] [ text "Cleaner view based on floor" ]
    Reception            -> div [] [ text "Reception where it can see all the floors/rooms" ]
    RouteNotFound        -> div [] [ text "The path doesn't exist :(" ]


----------------------
--- ADMIN ------------
----------------------
viewAdmin model =
  div [ ]
      [ 
        ]







----------------------
--- HOME -------------
----------------------
viewHome : Model -> Html Msg
viewHome model =
  div [ ]
      [ div [ class "icon" ] [ text "Here insert icon" ]
      , div [ class "buttons" ]
            [ button [ class "login", onClick LoginPage ] [ text "Login" ]
            , button [ class "register", onClick RegisterPage ] [ text "Register" ]
            ]
      ]


----------------------
--- REGISTER -------
----------------------
viewRegister : Model -> Html Msg
viewRegister model =
  div [ class "viewRegister" ]
      [ input [ class "name", placeholder "Name", type_ "text", onInput InputName ]                      [ ]
      , input [ class "hotelName", placeholder "Hotel Name", type_ "text", onInput InputHotelName ]           [ ]
      , input [ class "password", placeholder "Password", type_ "password", onInput InputPassword ]          [ ]
      , input [ class "rPassword", placeholder "Repeat Password", type_ "password",  onInput InputRPassword ] [ ]
      , button [ class "button", onClick SubmitRegisterRequest ] [ text "Submit" ]
      ]

checkRegisterData : RegisterData -> List CredentialError
checkRegisterData registerData =
  let
      password  = registerData.password
      rPassword = registerData.rPassword

      errorList =
        if password == rPassword then
          []
        else
          [ PasswordsDontMatch ]
  in
      errorList


----------------------
--- VIEW LOGIN -------
----------------------
viewLogin : Model -> Html msg
viewLogin model =
  div [ class "login" ]
      [ input [ class "name", placeholder "Name", type_ "text" ] []
      , input [ class "password", placeholder "Password", type_ "password" ] []
      , input [ class "hotel", placeholder "Hotel Name", type_ "text" ] []
      , button [ class "submit"] [ text "Submit" ]
      ]


-- UPDATE --
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Route location ->
      let
          newRoute = matchLocation location
      in
          ({model | route = newRoute}, Cmd.none )

    LoginPage ->
      ({ model | route = Login }, Navigation.newUrl("/#/login")) -- TODO: adauga o variabila sa tina asta

    RegisterPage ->
      ({ model | route = Register }, Navigation.newUrl("/#/register"))

-- TODO: Create input field function definition, need DRY
    InputName name ->
      let
          oldInput = model.registerData
          newInput = { oldInput | name = name }
      in
          ({ model | registerData = newInput } |> Debug.log "sup", Cmd.none)

    InputHotelName hotelName ->
      let
          oldInput = model.registerData
          newInput = { oldInput | hotelName = hotelName}
      in
          ({ model | registerData = newInput } |> Debug.log "sup", Cmd.none)

    InputPassword password ->
      let
          oldInput = model.registerData
          newInput = { oldInput | password = password}
      in
          ({ model | registerData = newInput } |> Debug.log "sup", Cmd.none)

    InputRPassword rPassword ->
      let
          oldInput = model.registerData
          newInput = { oldInput | rPassword = rPassword}
      in
          ({ model | registerData = newInput } |> Debug.log "sup", Cmd.none)

    SubmitRegisterRequest ->
      let
          checkRequestData = checkRegisterData model.registerData
      in
          if checkRequestData == [] then
            -- TODO: aici sa trimiti request catre server cu inregistrarea numelui
            (model , Cmd.none )
          else
            (model, Cmd.none)


-- SUBSCRIPTIONS --
--subscriptions : Routing.Model -> Sub msg
--  Sub.none
