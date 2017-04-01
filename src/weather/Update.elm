module Weather.Update exposing (update)

import Msg exposing (Msg(WeatherMsg))
import Weather.Types


update : Weather.Types.Msg -> Weather.Types.Model -> ( Weather.Types.Model, Cmd Msg )
update msg model =
    case msg of
        Weather.Types.WantWeather ->
            model ! []
