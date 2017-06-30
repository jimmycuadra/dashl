module Msg exposing (Msg(..))

import Timer.Types
import Weather.Types


type Msg
    = TimerMsg Timer.Types.Msg
    | WeatherMsg Weather.Types.Msg
