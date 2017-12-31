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


viewHome : String -> Html Msg
viewHome avatarUrl =
    Layout.view <|
        el None [ center ] (Home.view avatarUrl)


viewTalks : List Conference -> Html Msg
viewTalks =
    Layout.view << Talks.view


viewBooks : Html Msg
viewBooks =
    Layout.view Books.view
