module Model exposing (Model)

import Timer.Types
import Weather.Types


type alias Model =
    { timer : Timer.Types.Model
    , weather : Weather.Types.Model
    }
