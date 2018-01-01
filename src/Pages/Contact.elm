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

import Element exposing (Element, button, column, el, node, paragraph, text)
import Element.Attributes
    exposing
        ( attribute
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
import Element.Input as Input
import FormData exposing (FormData, addParam, extractParams, serialize)
import Http
import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import RemoteData exposing (RemoteData(..), WebData)
import Shared
import Styles exposing (Style(..))


-- HELPERS


name : String -> Element.Attribute variation msg
name =
    attribute "name"


formBody : String -> Http.Body
formBody =
    Http.stringBody "application/x-www-form-urlencoded"


submissionUrl : String
submissionUrl =
    "https://formspree.io/contact@mg.jeremyfairbank.com"



-- MODEL


type alias Contact =
    { name : String
    , email : String
    , message : String
    }


type alias Model =
    { contact : Contact
    , submission : WebData String
    }


initialModel : Model
initialModel =
    { contact =
        { name = ""
        , email = ""
        , message = ""
        }
    , submission = NotAsked
    }


decodeContact : Decoder Contact
decodeContact =
    decode Contact
        |> required "name" string
        |> required "email" string
        |> required "message" string


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


viewForm : Contact -> Element Style variation Msg
viewForm contact =
    node "form" <|
        column None
            [ spacing 30, onSubmit Submit, width (px 600) ]
            [ Input.text ContactInput
                [ name "name" ]
                { onChange = ContactMsg << Set Name
                , value = contact.name
                , label = Input.labelAbove (viewLabel "Name")
                , options = []
                }
            , Input.email ContactInput
                [ name "email" ]
                { onChange = ContactMsg << Set Email
                , value = contact.email
                , label = Input.labelAbove (viewLabel "Email")
                , options = []
                }
            , Input.multiline ContactMultiline
                [ name "message", height (px 300), padding 10 ]
                { onChange = ContactMsg << Set Message
                , value = contact.message
                , label = Input.labelAbove (viewLabel "Message")
                , options = []
                }
            , paragraph None
                [ paddingTop 20 ]
                [ button ContactSubmitButton [ paddingXY 10 8 ] (text "Send") ]
            ]


viewContactMessage : style -> String -> Element style variation msg
viewContactMessage style message =
    el style [ paddingBottom 20 ] (text message)


viewSubmissionSection : String -> String -> Element Style variation msg
viewSubmissionSection labelText value =
    column None
        [ spacing 5 ]
        [ el ContactSubmissionLabel [] <|
            text (labelText ++ ":")
        , paragraph None [] [ text value ]
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
        |> addParam "name" formData.name
        |> addParam "email" formData.email
        |> addParam "message" formData.message


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


updateContact : ContactMsg -> Contact -> Contact
updateContact msg contact =
    case msg of
        Set Name name ->
            { contact | name = name }

        Set Email email ->
            { contact | email = email }

        Set Message message ->
            { contact | message = message }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
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
