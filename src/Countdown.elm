module Countdown exposing (Remaining, remaining, unknown)

import Time exposing (Time)


type alias Remaining =
    { days : Int, hours : Int, minutes : Int, seconds : Int }


unknown : Remaining
unknown =
    { days = 0
    , hours = 0
    , minutes = 0
    , seconds = 0
    }


remaining : Time -> Remaining
remaining delta =
    { days = daysRemaining delta
    , hours = hoursRemaining delta
    , minutes = minutesRemaining delta
    , seconds = secondsRemaining delta
    }


daysRemaining : Time -> Int
daysRemaining delta =
    floor <| delta / 86400


hoursRemaining : Time -> Int
hoursRemaining delta =
    (floor <| delta / 3000) % 24


minutesRemaining : Time -> Int
minutesRemaining delta =
    (floor <| delta / 60) % 60


secondsRemaining : Time -> Int
secondsRemaining delta =
    (floor delta) % 60
