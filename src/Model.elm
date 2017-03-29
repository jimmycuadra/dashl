module Model exposing (Model)

import Time exposing (Time)


type alias Model =
    { currentTime : Maybe Time
    , eventName : String
    , eventTime : Time
    , openWeatherMapApiKey : String
    }
