module Weather.Subscriptions exposing (subscriptions)

import Time exposing (Time)
import Weather.Types


subscriptions : Weather.Types.Model -> Sub Weather.Types.Msg
subscriptions model =
    Time.every day Weather.Types.RefreshWeather


day : Time
day =
    Time.hour * 24
