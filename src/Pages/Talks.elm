module Pages.Talks exposing (view)

import Data.Conference exposing (Conference)
import Data.Talk exposing (Talk)
import Element exposing (Element, column, el, h1, h2, h3, newTab, row, text, whenJust)
import Element.Attributes exposing (padding, paddingBottom, spacing)
import Styles exposing (Style(..))


viewLink : String -> String -> Element Style variation msg
viewLink linkText url =
    el TalksTalkLink [] <|
        newTab url (text linkText)


viewTalk : Talk -> Element Style variation msg
viewTalk talk =
    column None
        [ spacing 5 ]
        [ h3 TalksTalkTitle [] (text talk.title)
        , row None
            [ spacing 20 ]
            [ whenJust talk.videoUrl (viewLink "Video")
            , viewLink "Slides" talk.slidesUrl
            ]
        ]


viewConference : Conference -> Element Style variation msg
viewConference conference =
    column TalksConference
        [ padding 20 ]
        [ h2 TalksConferenceName [ paddingBottom 10 ] (text conference.name)
        , column None
            [ spacing 20 ]
            (List.map viewTalk conference.talks)
        ]


view : List Conference -> Element Style variation msg
view conferences =
    column None
        [ spacing 20 ]
        [ h1 TalksHeading [] (text "Conference Talks")
        , column None
            [ spacing 30 ]
            (List.map viewConference conferences)
        ]
