module Pages.Books exposing (title, view)

import Element exposing (Element, text)


title : String
title =
    "Books"


view : Element style variation msg
view =
    text "Books Content"
