module Shared exposing (viewPageHeading)

import Element exposing (Element, h1, text)
import Styles exposing (Style(..))


viewPageHeading : String -> Element Style variation msg
viewPageHeading headingText =
    h1 PageHeading [] (text headingText)
