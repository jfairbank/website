port module PageTitle exposing (update)

import Pages.Books as Books
import Pages.Home as Home
import Pages.Talks as Talks
import Routes exposing (Route(..))


port title : String -> Cmd msg


routeToTitle : Maybe Route -> String
routeToTitle route =
    case route of
        Just Home ->
            Home.title

        Just Talks ->
            Talks.title

        Just Books ->
            Books.title

        Nothing ->
            "Not Found"


update : Maybe Route -> Cmd msg
update =
    routeToTitle >> title
