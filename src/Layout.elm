module Layout exposing (view)

import Data.Model exposing (Model)
import Element
    exposing
        ( Element
        , button
        , column
        , el
        , html
        , image
        , layout
        , link
        , mainContent
        , navigation
        , navigationColumn
        , newTab
        , row
        , sidebar
        , text
        )
import Element.Attributes exposing (center, fill, height, padding, paddingXY, px, spacing, width)
import Element.Events exposing (onWithOptions)
import Html exposing (Html, i)
import Html.Attributes exposing (class)
import Json.Decode exposing (succeed)
import Styles exposing (Style(..), stylesheet)
import Update exposing (Msg(..))


onClickPreventDefault : msg -> Element.Attribute variation msg
onClickPreventDefault msg =
    onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (succeed msg)


viewLink : String -> String -> Element Style variation msg
viewLink url linkText =
    link url <|
        el None [] (text linkText)


viewPushLink : String -> String -> Element Style variation Msg
viewPushLink url linkText =
    button ButtonLink [ onClickPreventDefault (Visit url) ] <|
        viewLink url linkText


viewBrand : Element Style variation msg
viewBrand =
    el Brand [] (text "Jeremy Fairbank")


viewNav : Element Style variation Msg
viewNav =
    navigationColumn None
        [ spacing 20 ]
        { name = "Main Navigation"
        , options =
            [ viewPushLink "/" "Home"
            , viewPushLink "/talks" "Talks"
            , viewLink "https://blog.jeremyfairbank.com" "Blog"
            ]
        }


viewIcon : String -> Element Style variation msg
viewIcon name =
    html <|
        i [ class ("fa fa-" ++ name) ] []


viewIconLink : String -> String -> Element Style variation msg
viewIconLink name url =
    newTab url <|
        viewIcon name


viewSocialLinks : Element Style variation msg
viewSocialLinks =
    navigation None
        [ spacing 15 ]
        { name = "Social Links"
        , options =
            [ viewIconLink "twitter" "https://twitter.com/elpapapollo"
            , viewIconLink "github" "https://github.com/jfairbank"
            , viewIconLink "linkedin-square" "https://www.linkedin.com/in/jfairbank"
            ]
        }


viewProgrammingElmAd : String -> Element Style variation msg
viewProgrammingElmAd programmingElmBetaUrl =
    let
        bookLink =
            link "https://pragprog.com/book/jfelm/programming-elm"
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


viewSidebar : String -> Element Style variation Msg
viewSidebar programmingElmBetaUrl =
    sidebar Sidebar
        [ padding 20, spacing 20, width (px 250) ]
        [ viewBrand
        , viewNav
        , viewSocialLinks
        , viewProgrammingElmAd programmingElmBetaUrl
        ]


view : Model -> Element Style variation Msg -> Html Msg
view model child =
    layout stylesheet <|
        row None
            [ height fill ]
            [ viewSidebar model.programmingElmBetaUrl
            , mainContent MainContent [ padding 20 ] child
            ]
