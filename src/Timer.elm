module Timer exposing (view)

import Model exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (class)
import Time exposing (Time)
import Update exposing (Msg)


view : Model -> List (Html Msg)
view model =
    [ eventDescriptionView model.description
    , timeRemaining model |> timeRemainingView
    ]


eventDescriptionView : String -> Html Msg
eventDescriptionView description =
    div [ class "row", class "event-description text-center" ]
        [ div [ class "col" ]
            [ h1 [ class "display-1" ]
                [ span [] [ text description ]
                , text " in"
                ]
            ]
        ]


timeRemainingView : Remaining -> Html Msg
timeRemainingView remaining =
    div [ class "row text-center" ]
        [ timeRemainingComponentView remaining.days "days"
        , timeRemainingComponentView remaining.hours "hours"
        , timeRemainingComponentView remaining.minutes "mins"
        , timeRemainingComponentView remaining.seconds "secs"
        ]


timeRemainingComponentView : Int -> String -> Html Msg
timeRemainingComponentView duration suffix =
    div [ class "col-3" ]
        [ h2 [ class "timer-value" ] [ text <| toString duration ]
        , div [ class "timer-unit" ] [ text suffix ]
        ]


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


timeRemaining : Model -> Remaining
timeRemaining model =
    case model.currentTime of
        Just currentTime ->
            model.eventTime - currentTime |> Time.inSeconds |> remaining

        Nothing ->
            unknown
