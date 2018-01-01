module Data.Model exposing (Model, decodeModel)

import Data.Conference exposing (Conference, decodeConference)
import Json.Decode exposing (Decoder, int, list, maybe, string)
import Json.Decode.Pipeline exposing (custom, decode, required)
import Pages.Contact as Contact
import Routes exposing (Route(..), decodeRoute)


type alias Model =
    { avatarUrl : String
    , programmingElmBetaUrl : String
    , conferences : List Conference
    , width : Int
    , height : Int
    , route : Maybe Route
    , contact : Contact.Model
    }


decodeModel : Decoder Model
decodeModel =
    decode Model
        |> required "avatarUrl" string
        |> required "programmingElmBetaUrl" string
        |> required "conferences" (list decodeConference)
        |> required "width" int
        |> required "height" int
        |> required "route" decodeRoute
        |> required "contact" Contact.decodeModel
