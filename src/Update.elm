module Update exposing (Msg(..), update)

import Data.Model exposing (Model)
import Navigation exposing (Location)
import Routes exposing (parseLocation)


type Msg
    = NewUrl Location
    | Visit String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl location ->
            ( { model | route = parseLocation location }
            , Cmd.none
            )

        Visit url ->
            ( model
            , Navigation.newUrl url
            )
