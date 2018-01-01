module Update exposing (Msg(..), update)

import Data.Model exposing (Model)
import Navigation exposing (Location)
import PageTitle
import Pages.Contact as Contact
import Routes exposing (parseLocation)
import Window


type Msg
    = NewUrl Location
    | Visit String
    | Resize Window.Size
    | ContactMsg Contact.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl location ->
            let
                route =
                    parseLocation location
            in
            ( { model
                | route = route
                , contact = Contact.initialModel
              }
            , PageTitle.update route
            )

        Visit url ->
            ( model
            , Navigation.newUrl url
            )

        Resize size ->
            ( { model | width = size.width, height = size.height }
            , Cmd.none
            )

        ContactMsg contactMsg ->
            let
                ( newContact, cmd ) =
                    Contact.update contactMsg model.contact
            in
            ( { model | contact = newContact }
            , Cmd.map ContactMsg cmd
            )
