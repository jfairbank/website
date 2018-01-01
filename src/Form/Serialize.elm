module Form.Serialize exposing (FormData, addParam, extractParams, serialize)


type alias Params =
    String


type FormData a
    = FormData Params a


serialize : a -> FormData a
serialize =
    FormData ""


addParam : String -> String -> a -> FormData (a -> b) -> FormData b
addParam name serializedValue value (FormData params f) =
    FormData (params ++ "&" ++ name ++ "=" ++ serializedValue) (f value)


extractParams : FormData a -> Params
extractParams (FormData params _) =
    params
