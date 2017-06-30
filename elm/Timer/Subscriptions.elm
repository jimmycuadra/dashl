module Timer.Subscriptions exposing (subscriptions)

import Timer.Types
import Time exposing (Time)


subscriptions : Timer.Types.Model -> Sub Timer.Types.Msg
subscriptions model =
    Time.every Time.second Timer.Types.Tick
