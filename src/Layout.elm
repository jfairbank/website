module Layout exposing (view)

import Data.Model exposing (Model)
import Element exposing (Element, column, layout, mainContent, row)
import Element.Attributes exposing (fill, height, paddingXY, width)
import Html exposing (Html)
import MainNav
import Sidebar
import Styles exposing (Style(..), mobileThreshold, stylesheet)
import Update exposing (Msg(..))


view : Model -> Element Style variation Msg -> Html Msg
view model child =
    let
        pageContent =
            mainContent MainContent [ paddingXY 40 20 ] child

        content =
            if model.width >= mobileThreshold then
                row Site
                    [ height fill ]
                    [ Sidebar.view model.programmingElmBetaUrl
                    , pageContent
                    ]
            else
                column Site
                    [ height fill ]
                    [ MainNav.viewMobile
                    , pageContent
                    ]
    in
    layout (stylesheet model) content
