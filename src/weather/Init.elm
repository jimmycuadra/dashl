module Weather.Init exposing (init)

import Weather.Types
import Weather.Update


init : Cmd Weather.Types.Msg
init =
    Weather.Update.fetchForecasts
