module Timer exposing (init)

import Task
import Time exposing (Time)
import Timer.Types


init : Cmd Timer.Types.Msg
init =
    Task.perform Timer.Types.Tick Time.now
