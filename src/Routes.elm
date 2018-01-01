module Routes exposing (Route(..), decodeRoute, parseLocation)

import Json.Decode as Decode exposing (Decoder)
import Navigation exposing (Location)
import UrlParser as Url exposing (map, oneOf, s, top)


type Route
    = Home
    | Talks
    | Books
    | Contact


routeParser : Url.Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Talks (s "talks")
        , map Books (s "books")
        , map Contact (s "contact")
        ]


parseLocation : Location -> Maybe Route
parseLocation location =
    Url.parsePath routeParser location


deserializeRoute : String -> Maybe Route
deserializeRoute route =
    case route of
        "Home" ->
            Just Home

        "Talks" ->
            Just Talks

        "Books" ->
            Just Books

        "Contact" ->
            Just Contact

        _ ->
            Nothing


decodeRoute : Decoder (Maybe Route)
decodeRoute =
    Decode.map deserializeRoute Decode.string
