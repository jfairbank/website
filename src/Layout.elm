module Layout exposing (view)

import Data.Model exposing (Model)
import Element
    exposing
        ( Element
        , column
        , el
        , image
        , layout
        , link
        , mainContent
        , navigation
        , navigationColumn
        , paragraph
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


viewLink : String -> Element Style variation msg -> Element Style variation msg
viewLink url linkEl =
    link url <|
        el None [] linkEl


viewPushLink : Style -> String -> Element Style variation Msg -> Element Style variation Msg
viewPushLink style url linkEl =
    el style [ onClickPreventDefault (Visit url) ] <|
        viewLink url linkEl


viewBrand : Element Style variation Msg
viewBrand =
    viewPushLink Brand "/" (text "Jeremy Fairbank")


type alias NavOptions variation =
    { home : Element Style variation Msg
    , talks : Element Style variation Msg
    , contact : Element Style variation Msg
    , blog : Element Style variation Msg
    }


navOptions : NavOptions variation
navOptions =
    { home = viewPushLink None "/" (text "Home")
    , talks = viewPushLink None "/talks" (text "Talks")
    , contact = viewPushLink None "/contact" (text "Contact")
    , blog = viewLink "https://blog.jeremyfairbank.com" (text "Blog")
    }


navConfig : List (Element Style variation Msg) -> NavConfig Style variation Msg
navConfig options =
    { name = "Main Navigation"
    , options = options
    }


viewNav : Element Style variation Msg
viewNav =
    navigationColumn None [ spacing 20 ] <|
        navConfig
            [ navOptions.home
            , navOptions.talks
            , navOptions.contact
            , navOptions.blog
            ]


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
    navigation MobileMenuNav [ spacing 30, width fill ] <|
        navConfig
            [ navOptions.talks
            , navOptions.contact
            , navOptions.blog
            ]


viewMobileMenu : Element Style variation Msg
viewMobileMenu =
    row MobileMenu
        [ padding 20, spacing 40, verticalCenter ]
        [ paragraph None
            [ width (px 75) ]
            [ viewPushLink None "/" <|
                el MobileMenuBrand [] <|
                    text "Jeremy Fairbank"
            ]
        , viewMobileNav
        ]


view : Model -> Element Style variation Msg -> Html Msg
view model child =
    let
        pageContent =
            mainContent MainContent [ paddingXY 40 20 ] child

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
