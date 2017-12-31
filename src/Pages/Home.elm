module Pages.Home exposing (title, view)

import Element exposing (Element, column, el, image, text)
import Element.Attributes exposing (center, px, spacing, width)
import Styles exposing (Style(..))


title : String
title =
    "Jeremy Fairbank"


view : String -> Element Style variation msg
view avatarUrl =
    column None
        [ center, spacing 10 ]
        [ image None
            [ width (px 400) ]
            { caption = "Jeremy Fairbank"
            , src = avatarUrl
            }
        , el HomeName [] (text "Jeremy Fairbank")
        , el HomeTagline [] (text "Developer. Speaker. Author.")
        ]
