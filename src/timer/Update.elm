module Timer.Update exposing (update)

import Msg exposing (Msg(TimerMsg))
import Timer.Types


update : Timer.Types.Msg -> Timer.Types.Model -> ( Timer.Types.Model, Cmd Msg )
update msg model =
    case msg of
        Timer.Types.Tick time ->
            { model | currentTime = time } ! []
