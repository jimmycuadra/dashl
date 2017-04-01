module Weather.Types exposing (..)

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


type alias DarkSkyData =
    { daily : Maybe Daily
    }


type alias Daily =
    { data : Maybe (List Forecast)
    }


type alias Forecast =
    { time : Maybe String
    , temperatureMax : Maybe String
    , temperatureMin : Maybe String
    }
