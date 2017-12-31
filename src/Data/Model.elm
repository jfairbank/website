module Data.Model exposing (Model)

import Data.Conference exposing (Conference)
import Routes exposing (Route(..))


type alias Model =
    { avatarUrl : String
    , programmingElmBetaUrl : String
    , conferences : List Conference
    , route : Maybe Route
    }
