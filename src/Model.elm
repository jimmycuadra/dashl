module Model exposing (Model)

import Time exposing (Time)


type alias Model =
    { eventName : String
    , currentTime : Maybe Time
    , eventTime : Time
    }
