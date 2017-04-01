module Timer.Types exposing (Model, Msg(..))

import Time exposing (Time)


type alias Model =
    { currentTime : Time
    , eventName : String
    , eventTime : Time
    }


type Msg
    = Tick Time
