module Prerender exposing (decodeBooks, decodeHome, decodeTalks, viewBooks, viewHome, viewTalks)

import Data.Conference exposing (Conference, decodeConferences)
import Html exposing (Html)
import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import Pages
import Update exposing (Msg)


type alias HomeModel =
    { programmingElmBetaUrl : String
    , avatarUrl : String
    }


decodeHome : Decoder HomeModel
decodeHome =
    decode HomeModel
        |> required "programmingElmBetaUrl" string
        |> required "avatarUrl" string


viewHome : HomeModel -> Html Msg
viewHome { programmingElmBetaUrl, avatarUrl } =
    Pages.viewHome programmingElmBetaUrl avatarUrl


type alias TalksModel =
    { programmingElmBetaUrl : String
    , conferences : List Conference
    }


decodeTalks : Decoder TalksModel
decodeTalks =
    decode TalksModel
        |> required "programmingElmBetaUrl" string
        |> required "conferences" decodeConferences


viewTalks : TalksModel -> Html Msg
viewTalks { programmingElmBetaUrl, conferences } =
    Pages.viewTalks programmingElmBetaUrl conferences


type alias BooksModel =
    { programmingElmBetaUrl : String }


decodeBooks : Decoder BooksModel
decodeBooks =
    decode BooksModel
        |> required "programmingElmBetaUrl" string


viewBooks : BooksModel -> Html Msg
viewBooks { programmingElmBetaUrl } =
    Pages.viewBooks programmingElmBetaUrl
