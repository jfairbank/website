module Main exposing (..)

import Data.Conference exposing (Conference)
import Data.Model exposing (Model)
import Element exposing (text)
import Html exposing (Html)
import Layout
import Navigation exposing (Location)
import PageTitle
import Pages
import Routes exposing (Route(..), parseLocation)
import Update exposing (Msg(..), update)
import Window


type alias Flags =
    { avatarUrl : String
    , programmingElmBetaUrl : String
    , conferences : List Conference
    , width : Int
    , height : Int
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        route =
            parseLocation location
    in
    ( { avatarUrl = flags.avatarUrl
      , programmingElmBetaUrl = flags.programmingElmBetaUrl
      , conferences = flags.conferences
      , width = flags.width
      , height = flags.height
      , route = route
      }
    , PageTitle.update route
    )


view : Model -> Html Msg
view model =
    case model.route of
        Just Home ->
            Pages.viewHome model

        Just Talks ->
            Pages.viewTalks model

        Just Books ->
            Pages.viewBooks model

        Nothing ->
            Layout.view model
                (text "404 Not Found")


subscriptions : Model -> Sub Msg
subscriptions _ =
    Window.resizes Resize


main : Program Flags Model Msg
main =
    Navigation.programWithFlags NewUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
