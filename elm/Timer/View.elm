module Timer.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time exposing (Time)
import Timer.Types


view : Timer.Types.Model -> Html Timer.Types.Msg
view model =
    div [ class "row widget" ]
        [ div [ class "col" ]
            [ eventNameView model.eventName
            , timeRemaining model |> timeRemainingView
            ]
        ]



-- private


type alias Remaining =
    { days : Int, hours : Int, minutes : Int, seconds : Int }


eventNameView : String -> Html Timer.Types.Msg
eventNameView eventName =
    div [ class "row event-name" ]
        [ div [ class "col" ]
            [ h1 []
                [ span [ class "widget-subject" ] [ text eventName ]
                , text " in"
                ]
            ]
        ]


timeRemainingView : Remaining -> Html Timer.Types.Msg
timeRemainingView remaining =
    div [ class "row" ]
        [ timeRemainingComponentView remaining.days "days"
        , timeRemainingComponentView remaining.hours "hours"
        , timeRemainingComponentView remaining.minutes "mins"
        , timeRemainingComponentView remaining.seconds "secs"
        ]


timeRemainingComponentView : Int -> String -> Html Timer.Types.Msg
timeRemainingComponentView duration suffix =
    div [ class "col-3" ]
        [ h2 [ class "timer-value" ] [ text <| toString duration ]
        , div [ class "timer-unit" ] [ text suffix ]
        ]


timeRemaining : Timer.Types.Model -> Remaining
timeRemaining model =
    model.eventTime - model.currentTime |> Time.inSeconds |> remaining


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
