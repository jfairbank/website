module Data.Talk exposing (..)

import Json.Decode exposing (Decoder, field, maybe, string)
import Json.Decode.Pipeline exposing (custom, decode, required)


type alias Talk =
    { title : String
    , slidesUrl : String
    , slidesEmbed : Maybe String
    , videoUrl : Maybe String
    }


decodeTalk : Decoder Talk
decodeTalk =
    decode Talk
        |> required "title" string
        |> required "slidesUrl" string
        |> custom (maybe (field "slidesEmbed" string))
        |> custom (maybe (field "videoUrl" string))
