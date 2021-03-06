module Weather.Types exposing (Model, Msg(..), DarkSkyData, Daily, Forecast)

import Time exposing (Time)
import RemoteData exposing (WebData)


type alias Model =
    { darkSkyApiKey : String
    , darkSkyData : WebData DarkSkyData
    , latitude : String
    , longitude : String
    , name : String
    }


type Msg
    = RenderWeather (WebData DarkSkyData)
    | RefreshWeather Time


type alias DarkSkyData =
    { daily : Maybe Daily
    }


type alias Daily =
    { data : Maybe (List Forecast)
    }


type alias Forecast =
    { time : Maybe Int
    , temperatureMax : Maybe Float
    , temperatureMin : Maybe Float
    }
