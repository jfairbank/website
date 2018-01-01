module Pages.Contact
    exposing
        ( Model
        , Msg
        , decodeModel
        , initialModel
        , title
        , update
        , view
        )

import Element exposing (Element, button, column, el, node, paragraph, row, text, whenJust)
import Element.Attributes
    exposing
        ( alignRight
        , fill
        , height
        , padding
        , paddingBottom
        , paddingTop
        , paddingXY
        , px
        , spacing
        , width
        )
import Element.Events exposing (onSubmit)
import Element.Extra.Attributes exposing (disabled, name)
import Element.Input as Input
import Form.Serialize exposing (FormData, addParam, extractParams, serialize)
import Form.Validation as Validation exposing (FormField, Validator)
import Http
import Json.Decode exposing (Decoder, map, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import RemoteData exposing (RemoteData(..), WebData)
import Shared
import Styles exposing (Style(..))


-- HELPERS


formBody : String -> Http.Body
formBody =
    Http.stringBody "application/x-www-form-urlencoded"


submissionUrl : String
submissionUrl =
    "https://formspree.io/contact@mg.jeremyfairbank.com"



-- CONTACT


type alias Contact =
    { name : FormField
    , email : FormField
    , message : FormField
    }


initialContact : Contact
initialContact =
    { name = Validation.initial
    , email = Validation.initial
    , message = Validation.initial
    }


decodeContact : Decoder Contact
decodeContact =
    decode Contact
        |> required "name" (string |> map validateName)
        |> required "email" (string |> map validateEmail)
        |> required "message" (string |> map validateMessage)



-- MODEL


type alias Model =
    { contact : Contact
    , submission : WebData String
    }


initialModel : Model
initialModel =
    { contact = initialContact
    , submission = NotAsked
    }


decodeModel : Decoder Model
decodeModel =
    decode Model
        |> required "contact" decodeContact
        |> hardcoded NotAsked



-- MSG


type Field
    = Name
    | Email
    | Message


type ContactMsg
    = Set Field String


type Msg
    = ContactMsg ContactMsg
    | Submit
    | Send (WebData String)



-- VIEW


title : String
title =
    "Contact Jeremy Fairbank"


viewLabel : String -> Element Style variation msg
viewLabel labelText =
    el ContactLabel [] <|
        text (labelText ++ ":")


viewError : String -> Element Style variation msg
viewError errorMessage =
    row None
        [ alignRight, width fill ]
        [ el ContactError [] (text errorMessage) ]


type alias ViewInputBuilderF style variation msg =
    List (Element.Attribute variation msg)
    -> Input.Text style variation msg
    -> Element style variation msg


type alias ViewInputConfig msg =
    { label : String
    , field : FormField
    , onChange : String -> msg
    }


viewInput :
    ViewInputBuilderF Style variation msg
    -> List (Element.Attribute variation msg)
    -> ViewInputConfig msg
    -> Element Style variation msg
viewInput builder attributes config =
    builder attributes
        { onChange = config.onChange
        , value = Validation.value config.field
        , label = Input.labelAbove (viewLabel config.label)
        , options =
            [ Input.errorAbove
                (config.field
                    |> Validation.error
                    |> flip whenJust viewError
                )
            ]
        }


contactIsValid : Contact -> Bool
contactIsValid contact =
    [ contact.name
    , contact.email
    , contact.message
    ]
        |> List.all Validation.isValid


viewForm : Contact -> Element Style variation Msg
viewForm contact =
    node "form" <|
        column None
            [ spacing 30, onSubmit Submit, width (px 600) ]
            [ viewInput (Input.text ContactInput)
                [ name "name" ]
                { label = "Name"
                , field = contact.name
                , onChange = ContactMsg << Set Name
                }
            , viewInput (Input.email ContactInput)
                [ name "email" ]
                { label = "Email"
                , field = contact.email
                , onChange = ContactMsg << Set Email
                }
            , viewInput (Input.multiline ContactMultiline)
                [ name "message", height (px 300), padding 10 ]
                { label = "Message"
                , field = contact.message
                , onChange = ContactMsg << Set Message
                }
            , paragraph None
                [ paddingTop 20 ]
                [ button ContactSubmitButton
                    [ disabled (not (contactIsValid contact))
                    , paddingXY 10 8
                    ]
                    (text "Send")
                ]
            ]


viewContactMessage : style -> String -> Element style variation msg
viewContactMessage style message =
    el style [ paddingBottom 20 ] (text message)


viewSubmissionSection : String -> FormField -> Element Style variation msg
viewSubmissionSection labelText formField =
    column None
        [ spacing 5 ]
        [ el ContactSubmissionLabel [] <|
            text (labelText ++ ":")
        , paragraph None [] [ text (Validation.value formField) ]
        ]


viewSubmission : Contact -> Element Style variation msg
viewSubmission contact =
    column None
        [ spacing 20, width (px 600) ]
        [ viewSubmissionSection "Name" contact.name
        , viewSubmissionSection "Email" contact.email
        , viewSubmissionSection "Message" contact.message
        ]


viewSuccess : Contact -> Element Style variation msg
viewSuccess contact =
    column None
        []
        [ viewContactMessage ContactSuccessMessage "Message sent!"
        , viewSubmission contact
        ]


viewFailure : Contact -> Element Style variation Msg
viewFailure contact =
    column None
        []
        [ viewContactMessage ContactErrorMessage
            "There was a problem sending. Please try again."
        , viewForm contact
        ]


viewContent : Model -> Element Style variation Msg
viewContent model =
    case model.submission of
        NotAsked ->
            viewForm model.contact

        Loading ->
            el ContactSending [] (text "Sending...")

        Failure _ ->
            viewFailure model.contact

        Success _ ->
            viewSuccess model.contact


view : Model -> Element Style variation Msg
view model =
    column None
        [ spacing 40 ]
        [ Shared.viewPageHeading "Contact Jeremy"
        , viewContent model
        ]



-- UPDATE


serializeContact : Contact -> FormData Contact
serializeContact formData =
    serialize Contact
        |> addParam "name" (Validation.value formData.name) formData.name
        |> addParam "email" (Validation.value formData.email) formData.email
        |> addParam "message" (Validation.value formData.message) formData.message


submit : Contact -> Cmd Msg
submit contact =
    Http.request
        { method = "POST"
        , headers = []
        , url = submissionUrl
        , body =
            contact
                |> serializeContact
                |> extractParams
                |> formBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
        |> RemoteData.sendRequest
        |> Cmd.map Send


validateName : Validator
validateName =
    Validation.validate
        [ Validation.isRequired "Please provide a name." ]


validateEmail : Validator
validateEmail =
    Validation.validate
        [ Validation.isRequired "Please provide an email."
        , Validation.isValidEmail "Please provide a valid email."
        ]


validateMessage : Validator
validateMessage =
    Validation.validate
        [ Validation.isRequired "Please provide a message." ]


updateContact : ContactMsg -> Contact -> Contact
updateContact msg contact =
    case msg of
        Set Name name ->
            { contact | name = validateName name }

        Set Email email ->
            { contact | email = validateEmail email }

        Set Message message ->
            { contact | message = validateMessage message }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContactMsg contactMsg ->
            ( { model | contact = updateContact contactMsg model.contact }
            , Cmd.none
            )

        Submit ->
            ( model, submit model.contact )

        Send result ->
            ( { model | submission = result }
            , Cmd.none
            )
