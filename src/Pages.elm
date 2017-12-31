module Pages exposing (viewBooks, viewHome, viewTalks)

import Data.Conference exposing (Conference)
import Element exposing (el)
import Element.Attributes exposing (center)
import Html exposing (Html)
import Layout
import Pages.Books as Books
import Pages.Home as Home
import Pages.Talks as Talks
import Styles exposing (Style(..))
import Update exposing (Msg)


viewHome : String -> String -> Html Msg
viewHome programmingElmBetaUrl avatarUrl =
    Layout.view programmingElmBetaUrl <|
        el None [ center ] (Home.view avatarUrl)


viewTalks : String -> List Conference -> Html Msg
viewTalks programmingElmBetaUrl =
    Layout.view programmingElmBetaUrl
        << Talks.view


viewBooks : String -> Html Msg
viewBooks programmingElmBetaUrl =
    Layout.view programmingElmBetaUrl Books.view
