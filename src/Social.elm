module Social exposing (IconSize(..), viewLinks)

import Element exposing (Element, html, navigation, newTab)
import Element.Attributes exposing (spacing)
import Html exposing (Html, i)
import Html.Attributes exposing (class)
import Styles exposing (Style(..), stylesheet)


type alias Config =
    { spacing : Float
    , iconSize : IconSize
    }


type IconSize
    = Small
    | Medium
    | Large


viewIcon : IconSize -> String -> Element Style variation msg
viewIcon iconSize name =
    let
        sizeClass =
            case iconSize of
                Small ->
                    ""

                Medium ->
                    "fa-2x"

                Large ->
                    "fa-3x"
    in
    html <|
        i [ class ("fa fa-" ++ name ++ " " ++ sizeClass) ] []


viewIconLink : IconSize -> String -> String -> Element Style variation msg
viewIconLink iconSize name url =
    newTab url <|
        viewIcon iconSize name


viewLinks : Config -> Element Style variation msg
viewLinks config =
    navigation None
        [ spacing config.spacing ]
        { name = "Social Links"
        , options =
            [ viewIconLink config.iconSize "twitter" "https://twitter.com/elpapapollo"
            , viewIconLink config.iconSize "github" "https://github.com/jfairbank"
            , viewIconLink config.iconSize "linkedin-square" "https://www.linkedin.com/in/jfairbank"
            ]
        }
