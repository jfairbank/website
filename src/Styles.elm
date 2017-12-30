module Styles exposing (Style(..), stylesheet)

import Color exposing (blue, rgb, rgba)
import Style exposing (StyleSheet, prop, style)
import Style.Color as Color
import Style.Font as Font


type Style
    = None
    | Sidebar
    | Brand
    | MainContent
    | ButtonLink
    | HomeName
    | HomeTagline
    | TalksHeading
    | TalksConference
    | TalksConferenceName
    | TalksTalkTitle
    | TalksTalkLink


fontSourceSansPro : Style.Property class variation
fontSourceSansPro =
    Font.typeface
        [ Font.font "Source Sans Pro"
        , Font.sansSerif
        ]


stylesheet : StyleSheet Style variation
stylesheet =
    Style.styleSheet
        [ style Sidebar
            [ Color.background (rgb 241 241 241)
            , Font.size 20
            , fontSourceSansPro
            ]
        , style Brand
            [ Font.size 26
            , Font.bold
            , fontSourceSansPro
            ]
        , style MainContent
            [ Font.size 20
            , fontSourceSansPro
            , prop "overflow" "auto"
            ]
        , style ButtonLink
            [ Color.background (rgba 0 0 0 0) ]
        , style HomeName
            [ Font.size 80
            , Font.light
            , fontSourceSansPro
            ]
        , style HomeTagline
            [ Font.size 40
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
