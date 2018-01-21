module Social exposing (IconSize(..), viewLinks)

import Element exposing (Element, el, html, navigation, newTab)
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
    el SocialIconLink [] <|
        html <|
            i [ class ("fa fa-" ++ name ++ " " ++ sizeClass) ] []


viewIconLink : IconSize -> String -> String -> Element Style variation msg
viewIconLink iconSize name url =
    newTab url <|
        viewIcon iconSize name


viewLinks : Config -> Element Style variation msg
viewLinks config =
    let
        viewIcon =
            viewIconLink config.iconSize
    in
    navigation None
        [ spacing config.spacing ]
        { name = "Social Links"
        , options =
            [ viewIcon "twitter" "https://twitter.com/elpapapollo"
            , viewIcon "github" "https://github.com/jfairbank"
            , viewIcon "youtube" "https://www.youtube.com/c/JeremyFairbank"
            , viewIcon "linkedin-square" "https://www.linkedin.com/in/jfairbank"
            ]
        }
