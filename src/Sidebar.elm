module Sidebar exposing (view)

import Element exposing (Element, column, el, image, sidebar, text)
import Element.Attributes exposing (center, padding, paddingXY, px, spacing, width)
import MainNav
import Nav
import Social exposing (IconSize(..))
import Styles exposing (Style(..))
import Update exposing (Msg(..))


viewBrand : Element Style variation Msg
viewBrand =
    MainNav.pushLink Brand "/" (text "Jeremy Fairbank")


viewProgrammingElmAd : String -> Element Style variation msg
viewProgrammingElmAd programmingElmBetaUrl =
    let
        bookLink =
            Nav.link None "https://pragprog.com/book/jfelm/programming-elm"
    in
    column ProgrammingElmSideAd
        [ center, spacing 10 ]
        [ bookLink <|
            image None
                [ width (px 140) ]
                { caption = "Programming Elm Beta Cover"
                , src = programmingElmBetaUrl
                }
        , text "Programming Elm now in Beta"
        , el ProgrammingElmSideAdButton [ paddingXY 10 8 ] <|
            bookLink <|
                text "Buy Now!"
        ]


view : String -> Element Style variation Msg
view programmingElmBetaUrl =
    sidebar Sidebar
        [ padding 20, spacing 20, width (px 250) ]
        [ viewBrand
        , MainNav.view
        , Social.viewLinks
            { spacing = 15
            , iconSize = Small
            }
        , viewProgrammingElmAd programmingElmBetaUrl
        ]
