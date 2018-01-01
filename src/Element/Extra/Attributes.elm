module Element.Extra.Attributes exposing (disabled, name)

import Element exposing (Attribute)
import Element.Attributes exposing (attribute, property)
import Json.Encode as Json


name : String -> Attribute variation msg
name =
    attribute "name"


disabled : Bool -> Attribute variation msg
disabled value =
    property "disabled" (Json.bool value)
