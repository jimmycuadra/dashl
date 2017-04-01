module Weather.Types exposing (Model, Msg(..))


type alias Model =
    { darkSkyApiKey : String
    , forecasts : List ()
    , latitude : String
    , longitude : String
    , name : String
    }


type Msg
    = WantWeather
