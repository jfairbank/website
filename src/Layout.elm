module Layout exposing (view)

import Data.Model exposing (Model)
import Element
    exposing
        ( Element
        , button
        , column
        , el
        , image
        , layout
        , link
        , mainContent
        , navigation
        , navigationColumn
        , row
        , sidebar
        , text
        )
import Element.Attributes
    exposing
        ( alignRight
        , center
        , fill
        , height
        , padding
        , paddingXY
        , px
        , spacing
        , verticalCenter
        , width
        )
import Element.Events exposing (onWithOptions)
import Html exposing (Html)
import Json.Decode exposing (succeed)
import Social exposing (IconSize(..))
import Styles exposing (Style(..), mobileThreshold, stylesheet)
import Update exposing (Msg(..))


type alias NavConfig style variation msg =
    { name : String
    , options : List (Element style variation msg)
    }


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


navConfig : NavConfig Style variation Msg
navConfig =
    { name = "Main Navigation"
    , options =
        [ viewPushLink "/" "Home"
        , viewPushLink "/talks" "Talks"
        , viewPushLink "/contact" "Contact"
        , viewLink "https://blog.jeremyfairbank.com" "Blog"
        ]
    }


viewNav : Element Style variation Msg
viewNav =
    navigationColumn None
        [ spacing 20 ]
        navConfig


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
        , Social.viewLinks
            { spacing = 15
            , iconSize = Small
            }
        , viewProgrammingElmAd programmingElmBetaUrl
        ]


viewMobileNav : Element Style variation Msg
viewMobileNav =
    navigation MobileMenuNav [ spacing 30, width fill ] navConfig


viewMobileMenu : Element Style variation Msg
viewMobileMenu =
    row MobileMenu
        [ padding 20, spacing 40, verticalCenter ]
        [ column MobileMenuBrand
            [ alignRight ]
            [ text "Jeremy"
            , text "Fairbank"
            ]
        , viewMobileNav
        ]


view : Model -> Element Style variation Msg -> Html Msg
view model child =
    let
        pageContent =
            mainContent MainContent [ padding 20 ] child

        content =
            if model.width >= mobileThreshold then
                row Site
                    [ height fill ]
                    [ viewSidebar model.programmingElmBetaUrl
                    , pageContent
                    ]
            else
                column Site
                    [ height fill ]
                    [ viewMobileMenu
                    , pageContent
                    ]
    in
    layout (stylesheet model) content
