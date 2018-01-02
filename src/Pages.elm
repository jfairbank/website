module Pages exposing (viewBooks, viewContact, viewHome, viewTalks)

import Data.Model exposing (Model)
import Element exposing (el)
import Element.Attributes exposing (center)
import Html exposing (Html)
import Layout
import Pages.Books as Books
import Pages.Contact as Contact
import Pages.Home as Home
import Pages.Talks as Talks
import Styles exposing (Style(..))
import Update exposing (Msg(..))


viewHome : Model -> Html Msg
viewHome model =
    Layout.view model <|
        el None [ center ] (Home.view model)


viewTalks : Model -> Html Msg
viewTalks model =
    Layout.view model <|
        Talks.view model.conferences


viewBooks : Model -> Html Msg
viewBooks model =
    Layout.view model Books.view


viewContact : Model -> Html Msg
viewContact model =
    Layout.view model <|
        Element.map ContactMsg (Contact.view model.width model.contact)
