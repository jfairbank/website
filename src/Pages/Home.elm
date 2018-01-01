module Pages.Home exposing (title, view)

import Data.Model exposing (Model)
import Element exposing (Element, column, el, image, text)
import Element.Attributes exposing (center, px, spacing, width)
import Social exposing (IconSize(..))
import Styles exposing (Style(..), mobileResponsiveChoice)


title : String
title =
    "Jeremy Fairbank"


view : Model -> Element Style variation msg
view model =
    let
        ( imageWidth, iconSize ) =
            mobileResponsiveChoice model.width
                ( ( px 400, Large )
                , ( px 300, Medium )
                )
    in
    column None
        [ center, spacing 15 ]
        [ image None
            [ width imageWidth ]
            { caption = "Jeremy Fairbank"
            , src = model.avatarUrl
            }
        , el HomeName [] (text "Jeremy Fairbank")
        , el HomeTagline [] (text "Developer. Speaker. Author.")
        , Social.viewLinks
            { spacing = 40
            , iconSize = iconSize
            }
        ]
