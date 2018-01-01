module Styles
    exposing
        ( Style(..)
        , mobileResponsiveChoice
        , mobileThreshold
        , responsiveChoice
        , stylesheet
        )

import Color exposing (blue, rgb, rgba, white)
import Style exposing (StyleSheet, prop, style)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font


type alias WindowSize a =
    { a | width : Int, height : Int }


type alias ResponsiveChoiceConfig a =
    { threshold : Int
    , above : a
    , below : a
    }


type Style
    = None
    | Site
    | Sidebar
    | ProgrammingElmSideAd
    | ProgrammingElmSideAdButton
    | Brand
    | MobileMenu
    | MobileMenuBrand
    | MobileMenuNav
    | MainContent
    | ButtonLink
    | HomeName
    | HomeTagline
    | TalksHeading
    | TalksConference
    | TalksConferenceName
    | TalksTalkTitle
    | TalksTalkLink


mobileThreshold : Int
mobileThreshold =
    820


fontSourceSansPro : Style.Property class variation
fontSourceSansPro =
    Font.typeface
        [ Font.font "Source Sans Pro"
        , Font.sansSerif
        ]


responsiveChoice : Int -> ResponsiveChoiceConfig a -> a
responsiveChoice current config =
    if current >= config.threshold then
        config.above
    else
        config.below


mobileResponsiveChoice : Int -> ( a, a ) -> a
mobileResponsiveChoice current ( above, below ) =
    responsiveChoice current
        { threshold = mobileThreshold
        , above = above
        , below = below
        }


stylesheet : WindowSize a -> StyleSheet Style variation
stylesheet size =
    Style.styleSheet
        [ style Site
            [ fontSourceSansPro ]
        , style Sidebar
            [ Color.background (rgb 241 241 241)
            , Font.size 20

            -- , fontSourceSansPro
            ]
        , style ProgrammingElmSideAd
            [ Font.size 16
            , fontSourceSansPro
            , prop "margin-bottom" "60px !important"
            , prop "margin-top" "auto !important"
            ]
        , style ProgrammingElmSideAdButton
            [ Border.rounded 4
            , Color.background blue
            , Color.text white
            , Font.size 18
            ]
        , style Brand
            [ Font.size 26
            , Font.bold
            , fontSourceSansPro
            ]
        , style MobileMenu
            [ Color.background (rgb 241 241 241) ]
        , style MobileMenuBrand
            [ Font.bold
            , Font.size 18
            ]
        , style MobileMenuNav
            [ Font.size 22 ]
        , style MainContent
            [ Font.size 20
            , fontSourceSansPro
            , prop "overflow" <|
                mobileResponsiveChoice size.width ( "auto", "visible" )
            ]
        , style ButtonLink
            [ Color.background (rgba 0 0 0 0) ]
        , style HomeName
            [ Font.size <|
                mobileResponsiveChoice size.width ( 80, 46 )
            , Font.light
            , fontSourceSansPro
            ]
        , style HomeTagline
            [ Font.size <|
                mobileResponsiveChoice size.width ( 40, 24 )
            , Font.italic
            , Font.light
            , fontSourceSansPro
            ]
        , style TalksHeading
            [ Font.size 40
            , Font.bold
            , fontSourceSansPro
            ]
        , style TalksConference
            [ Color.background (rgb 241 241 241) ]
        , style TalksConferenceName
            [ Font.size 26
            , Font.bold
            , fontSourceSansPro
            ]
        , style TalksTalkLink
            [ Color.text blue
            , Font.underline
            ]
        ]
