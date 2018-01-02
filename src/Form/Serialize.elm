module Form.Serialize exposing (FormData, addParam, serialize, toJson)

import Json.Encode exposing (Value, object, string)


type InternalFormData a data
    = InternalFormData (List ( String, Value )) a data


type alias FormData a =
    InternalFormData a a


serialize : a -> data -> InternalFormData a data
serialize =
    InternalFormData []


addParam :
    String
    -> (data -> value)
    -> (value -> String)
    -> InternalFormData (value -> a) data
    -> InternalFormData a data
addParam name extractValue serializeValue (InternalFormData fields f data) =
    let
        value =
            extractValue data

        newField =
            ( name, string (serializeValue value) )
    in
    InternalFormData (newField :: fields) (f value) data


toJson : InternalFormData a data -> Value
toJson (InternalFormData fields _ _) =
    object fields
