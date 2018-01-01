module FormData exposing (FormData, addParam, extractParams, serialize)


type alias Params =
    String


type FormData a
    = FormData Params a


serialize : a -> FormData a
serialize =
    FormData ""


addParam : String -> String -> FormData (String -> a) -> FormData a
addParam name value (FormData params f) =
    FormData (params ++ "&" ++ name ++ "=" ++ value) (f value)


extractParams : FormData a -> Params
extractParams (FormData params _) =
    params
