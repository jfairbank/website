module Layout exposing (view)

import Element exposing (Element, button, el, html, layout, link, mainContent, navigation, navigationColumn, newTab, row, sidebar, text)
import Element.Attributes exposing (center, fill, height, maxWidth, padding, paddingLeft, px, spacing, width)
import Element.Events exposing (onClick)
import Html exposing (Html, i)
import Html.Attributes exposing (class)
import Styles exposing (Style(..), stylesheet)
import Update exposing (Msg(..))


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


view : Element Style variation Msg -> Html Msg
view child =
    layout stylesheet <|
        row None
            [ height fill ]
            [ viewSidebar
            , mainContent MainContent [ padding 20 ] child
            ]