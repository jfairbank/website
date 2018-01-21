module Nav exposing (link, pushLink)

import Element exposing (Element, el)
import Element.Events exposing (onWithOptions)
import Json.Decode exposing (succeed)


link : style -> String -> Element style variation msg -> Element style variation msg
link style url linkEl =
    el style [] <|
        Element.link url linkEl


pushLink : (String -> msg) -> style -> String -> Element style variation msg -> Element style variation msg
pushLink tagger style url linkEl =
    el style [ onClickPreventDefault (tagger url) ] <|
        Element.link url linkEl


onClickPreventDefault : msg -> Element.Attribute variation msg
onClickPreventDefault msg =
    onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (succeed msg)
