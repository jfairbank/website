module Styles
    exposing
        ( Style(..)
        , mobileResponsiveChoice
        , mobileThreshold
        , responsiveChoice
        , stylesheet
        )

import Color exposing (Color, blue, darkGreen, red, rgb, rgba, white)
import Style exposing (Property, StyleSheet, opacity, prop, pseudo, style, variation)
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
    | PageHeading
    | HomeName
    | HomeTagline
    | TalksConference
    | TalksConferenceName
    | TalksTalkTitle
    | TalksTalkLink
    | ContactInput
    | ContactMultiline
    | ContactLabel
    | ContactSubmitButton
    | ContactSending
    | ContactSuccessMessage
    | ContactErrorMessage
    | ContactSubmissionLabel
    | ContactError


disabled : List (Property class variation) -> Property class variation
disabled =
    pseudo "disabled"


mobileThreshold : Int
mobileThreshold =
    840


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


contactMessage : Color -> List (Property class variation)
contactMessage textColor =
    [ Color.text textColor
    , Font.bold
    , Font.size 28
    ]


stylesheet : WindowSize a -> StyleSheet Style variation
stylesheet size =
    Style.styleSheet
        [ style Site
            [ Font.typeface
                [ Font.font "Source Sans Pro"
                , Font.sansSerif
                ]
            ]
        , style Sidebar
            [ Color.background (rgb 241 241 241)
            , Font.size 20
            ]
        , style ProgrammingElmSideAd
            [ Font.size 16
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
            , prop "overflow" <|
                mobileResponsiveChoice size.width ( "auto", "visible" )
            ]
        , style PageHeading
            [ Font.size 40
            , Font.bold
            ]
        , style HomeName
            [ Font.size <|
                mobileResponsiveChoice size.width ( 80, 46 )
            , Font.light
            ]
        , style HomeTagline
            [ Font.size <|
                mobileResponsiveChoice size.width ( 40, 24 )
            , Font.italic
            , Font.light
            ]
        , style TalksConference
            [ Color.background (rgb 241 241 241) ]
        , style TalksConferenceName
            [ Font.size 26
            , Font.bold
            ]
        , style TalksTalkLink
            [ Color.text blue
            , Font.underline
            ]
        , style ContactInput
            [ Border.bottom 1
            , Border.solid
            ]
        , style ContactMultiline
            [ Border.all 1
            , Border.solid
            ]
        , style ContactLabel
            [ Font.bold ]
        , style ContactSubmitButton
            [ Border.rounded 4
            , Color.background blue
            , Color.text white
            , Font.size 26
            , disabled
                [ opacity 0.8 ]
            ]
        , style ContactSending
            [ Font.italic
            , Font.size 40
            ]
        , style ContactSuccessMessage <|
            contactMessage darkGreen
        , style ContactErrorMessage <|
            contactMessage red
        , style ContactSubmissionLabel
            [ Font.bold
            , Font.size 24
            ]
        , style ContactError
            [ Color.text red ]
        ]
