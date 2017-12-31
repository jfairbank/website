module Update exposing (Msg(..), update)

import Data.Model exposing (Model)
import Navigation exposing (Location)
import PageTitle
import Routes exposing (parseLocation)


type Msg
    = NewUrl Location
    | Visit String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl location ->
            let
                route =
                    parseLocation location
            in
            ( { model | route = route }
            , PageTitle.update route
            )

        Visit url ->
            ( model
            , Navigation.newUrl url
            )
