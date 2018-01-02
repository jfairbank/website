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
        , content
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
import Form.Serialize exposing (FormData, addParam, serialize, toJson)
import Form.Validation as Validation exposing (FormField, Validator)
import Http
import Json.Decode exposing (Decoder, map, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import RemoteData exposing (RemoteData(..), WebData)
import Shared
import Styles exposing (Style(..), mobileResponsiveChoice, mobileThreshold)


-- HELPERS


formBody : String -> Http.Body
formBody =
    Http.stringBody "application/x-www-form-urlencoded"


submissionUrl : String
submissionUrl =
    "https://formspree.io/contact@mg.jeremyfairbank.com"


maxContentWidth : Int -> Element.Attribute variation msg
maxContentWidth deviceWidth =
    width <|
        if deviceWidth >= 900 then
            px 600
        else if deviceWidth < mobileThreshold then
            fill
        else
            px 500



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
    , submission : WebData ()
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
    | Send (WebData ())



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


viewSubmitButton : Int -> Contact -> Element Style variation msg
viewSubmitButton deviceWidth contact =
    paragraph None
        [ paddingTop 20 ]
        [ button ContactSubmitButton
            [ disabled (not (contactIsValid contact))
            , paddingXY 10 8
            , width <|
                mobileResponsiveChoice deviceWidth ( content, fill )
            ]
            (text "Send")
        ]


viewForm : Int -> Contact -> Element Style variation Msg
viewForm deviceWidth contact =
    node "form" <|
        column None
            [ spacing 30, onSubmit Submit ]
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
            , viewSubmitButton deviceWidth contact
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
        [ spacing 20 ]
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


viewFailure : Int -> Contact -> Element Style variation Msg
viewFailure deviceWidth contact =
    column None
        []
        [ viewContactMessage ContactErrorMessage
            "There was a problem sending. Please try again."
        , viewForm deviceWidth contact
        ]


viewContent : Int -> Model -> Element Style variation Msg
viewContent deviceWidth model =
    case model.submission of
        NotAsked ->
            viewForm deviceWidth model.contact

        Loading ->
            el ContactSending [] (text "Sending...")

        Failure _ ->
            viewFailure deviceWidth model.contact

        Success _ ->
            viewSuccess model.contact


view : Int -> Model -> Element Style variation Msg
view deviceWidth model =
    column None
        [ spacing 40 ]
        [ Shared.viewPageHeading "Contact Jeremy"
        , el None [ maxContentWidth deviceWidth ] <|
            viewContent deviceWidth model
        ]



-- UPDATE


serializeContact : Contact -> FormData Contact
serializeContact contact =
    serialize Contact contact
        |> addParam "name" .name Validation.value
        |> addParam "email" .email Validation.value
        |> addParam "message" .message Validation.value


submit : Contact -> Cmd Msg
submit contact =
    let
        body =
            contact
                |> serializeContact
                |> toJson
                |> Http.jsonBody
    in
    Http.post submissionUrl body (succeed ())
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
            ( { model | submission = Loading }
            , submit model.contact
            )

        Send result ->
            ( { model | submission = result }
            , Cmd.none
            )
