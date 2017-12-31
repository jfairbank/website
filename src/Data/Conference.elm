module Data.Conference exposing (..)

import Data.Talk exposing (Talk, decodeTalk)
import Json.Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Conference =
    { name : String
    , url : String
    , location : String
    , talks : List Talk
    }


decodeConference : Decoder Conference
decodeConference =
    decode Conference
        |> required "name" string
        |> required "url" string
        |> required "location" string
        |> required "talks" (list decodeTalk)


decodeConferences : Decoder (List Conference)
decodeConferences =
    list decodeConference
