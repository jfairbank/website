module Routes exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser as Url exposing (map, oneOf, s, top)


type Route
    = Home
    | Talks
    | Books


routeParser : Url.Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Talks (s "talks")
        , map Books (s "books")
        ]


parseLocation : Location -> Maybe Route
parseLocation location =
    Url.parsePath routeParser location
