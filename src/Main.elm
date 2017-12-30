module Main exposing (..)

import Data.Conference exposing (Conference)
import Element exposing (Element, button, el, html, layout, link, mainContent, navigation, navigationColumn, newTab, row, sidebar, text)
import Element.Attributes exposing (center, fill, height, maxWidth, padding, paddingLeft, px, spacing, width)
import Element.Events exposing (onClick)
import Html exposing (Html, i)
import Html.Attributes exposing (class)
import Navigation exposing (Location)
import Pages.Books as Books
import Pages.Home as Home
import Pages.Talks as Talks
import Styles exposing (Style(..), stylesheet)
import UrlParser as Url exposing (map, oneOf, s, top)


---- MODEL ----


type Route
    = Home
    | Talks
    | Books


type alias Flags =
    { avatarUrl : String
    , conferences : List Conference
    }


type alias Model =
    { avatarUrl : String
    , conferences : List Conference
    , route : Maybe Route
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    ( { avatarUrl = flags.avatarUrl
      , conferences = flags.conferences
      , route = parseLocation location
      }
    , Cmd.none
    )


routeParser : Url.Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Talks (s "talks")
        , map Books (s "books")
        ]


parseLocation : Location -> Maybe Route
parseLocation location =
    Url.parsePath routeParser location



---- UPDATE ----


type Msg
    = NewUrl Location
    | Visit String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl location ->
            ( { model | route = parseLocation location }
            , Cmd.none
            )

        Visit url ->
            ( model
            , Navigation.newUrl url
            )



---- VIEW ----


viewLink : String -> String -> Element Style variation msg
viewLink url linkText =
    link url <|
        el None [] (text linkText)


viewButtonLink : String -> String -> Element Style variation Msg
viewButtonLink url linkText =
    button ButtonLink [ onClick (Visit url) ] (text linkText)


viewBrand : Element Style variation msg
viewBrand =
    el Brand [] (text "Jeremy Fairbank")


viewNav : Element Style variation Msg
viewNav =
    navigationColumn None
        [ spacing 20 ]
        { name = "Main Navigation"
        , options =
            [ viewButtonLink "/" "Home"
            , viewButtonLink "/talks" "Talks"

            -- , viewButtonLink "/books" "Books"
            , viewLink "https://blog.jeremyfairbank.com" "Blog"
            ]
        }


viewIcon : String -> Element Style variation msg
viewIcon name =
    html <|
        i [ class ("fa fa-" ++ name) ] []


viewIconLink : String -> String -> Element Style variation msg
viewIconLink name url =
    newTab url <|
        viewIcon name


viewSocialLinks : Element Style variation msg
viewSocialLinks =
    navigation None
        [ spacing 15 ]
        { name = "Social Links"
        , options =
            [ viewIconLink "twitter" "https://twitter.com/elpapapollo"
            , viewIconLink "github" "https://github.com/jfairbank"
            , viewIconLink "linkedin-square" "https://www.linkedin.com/in/jfairbank"
            ]
        }


viewSidebar : Element Style variation Msg
viewSidebar =
    sidebar Sidebar
        [ padding 20, spacing 20, width (px 250) ]
        [ viewBrand
        , viewNav
        , viewSocialLinks
        ]


viewMainContent : Model -> Element Style variation msg
viewMainContent model =
    mainContent MainContent [ padding 20 ] <|
        case model.route of
            Just Home ->
                -- el None [ paddingLeft 100 ] (Home.view model.avatarUrl)
                el None [ center ] (Home.view model.avatarUrl)

            Just Talks ->
                Talks.view model.conferences

            Just Books ->
                Books.view

            Nothing ->
                text "404 Not Found"


view : Model -> Html Msg
view model =
    layout stylesheet <|
        row None
            [ height fill ]
            [ viewSidebar
            , viewMainContent model
            ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Navigation.programWithFlags NewUrl
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
