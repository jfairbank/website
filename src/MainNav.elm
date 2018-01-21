module MainNav exposing (pushLink, view, viewMobile)

import Element exposing (Element, el, navigation, navigationColumn, paragraph, row, text)
import Element.Attributes exposing (fill, padding, px, spacing, verticalCenter, width)
import Nav
import Styles exposing (Style(..))
import Update exposing (Msg(..))


type alias NavConfig style variation msg =
    { name : String
    , options : List (Element style variation msg)
    }


type alias NavOptions variation =
    { home : Element Style variation Msg
    , talks : Element Style variation Msg
    , contact : Element Style variation Msg
    , blog : Element Style variation Msg
    }


pushLink : style -> String -> Element style variation Msg -> Element style variation Msg
pushLink =
    Nav.pushLink Visit


menuLink : String -> Element Style variation msg -> Element Style variation msg
menuLink =
    Nav.link MenuLink


menuPushLink : String -> Element Style variation Msg -> Element Style variation Msg
menuPushLink =
    pushLink MenuLink


navOptions : NavOptions variation
navOptions =
    { home = menuPushLink "/" (text "Home")
    , talks = menuPushLink "/talks" (text "Talks")
    , contact = menuPushLink "/contact" (text "Contact")
    , blog = menuLink "https://blog.jeremyfairbank.com" (text "Blog")
    }


navConfig : List (Element Style variation Msg) -> NavConfig Style variation Msg
navConfig options =
    { name = "Main Navigation"
    , options = options
    }


view : Element Style variation Msg
view =
    navigationColumn None [ spacing 20 ] <|
        navConfig
            [ navOptions.home
            , navOptions.talks
            , navOptions.contact
            , navOptions.blog
            ]


viewMobileNav : Element Style variation Msg
viewMobileNav =
    navigation MobileMenuNav [ spacing 30, width fill ] <|
        navConfig
            [ navOptions.talks
            , navOptions.contact
            , navOptions.blog
            ]


viewMobile : Element Style variation Msg
viewMobile =
    row MobileMenu
        [ padding 20, spacing 40, verticalCenter ]
        [ paragraph None
            [ width (px 75) ]
            [ pushLink None "/" <|
                el MobileMenuBrand [] <|
                    text "Jeremy Fairbank"
            ]
        , viewMobileNav
        ]
