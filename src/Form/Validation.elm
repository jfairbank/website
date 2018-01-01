module Form.Validation
    exposing
        ( FormField
        , Validator
        , error
        , initial
        , isRequired
        , isValid
        , isValidEmail
        , validate
        , value
        )

import Regex


type FormField
    = Initial
    | Valid String
    | Invalid String String


type alias ValidatorF =
    String -> Result String String


type alias Validator =
    String -> FormField



-- HELPERS


isErr : Result error value -> Bool
isErr result =
    case result of
        Ok _ ->
            False

        Err _ ->
            True



-- CREATE FIELDS


initial : FormField
initial =
    Initial



-- EXTRACT DATA


value : FormField -> String
value formField =
    case formField of
        Initial ->
            ""

        Valid fieldValue ->
            fieldValue

        Invalid fieldValue _ ->
            fieldValue


error : FormField -> Maybe String
error formField =
    case formField of
        Invalid _ errorMessage ->
            Just errorMessage

        _ ->
            Nothing



-- QUERY


isValid : FormField -> Bool
isValid formField =
    case formField of
        Valid _ ->
            True

        _ ->
            False



-- VALIDATE


validate : List ValidatorF -> Validator
validate validations value =
    validations
        |> List.map (\f -> f value)
        |> List.filter isErr
        |> List.head
        |> (\result ->
                case result of
                    Just (Err errorMessage) ->
                        Invalid value errorMessage

                    _ ->
                        Valid value
           )



-- COMMON VALIDATIONS


isRequired : String -> String -> Result String String
isRequired errorMessage value =
    if String.trim value == "" then
        Err errorMessage
    else
        Ok value



-- https://github.com/rtfeldman/elm-validate


isValidEmail : String -> String -> Result String String
isValidEmail errorMessage value =
    let
        validEmail =
            Regex.regex "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                |> Regex.caseInsensitive
    in
    if Regex.contains validEmail value then
        Ok value
    else
        Err errorMessage
