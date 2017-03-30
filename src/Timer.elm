module Timer exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Task
import Time exposing (Time)


type alias Model =
    { currentTime : Maybe Time
    , eventName : String
    , eventTime : Time
    }


type Msg
    = Tick Time


init : Cmd Msg
init =
    Task.perform Tick Time.now


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            { model | currentTime = Just time } ! []


view : Model -> Html Msg
view model =
    div []
        [ eventNameView model.eventName
        , timeRemaining model |> timeRemainingView
        ]



-- private


eventNameView : String -> Html Msg
eventNameView eventName =
    div [ class "row", class "event-name text-center" ]
        [ div [ class "col" ]
            [ h1 [ class "display-1" ]
                [ span [] [ text eventName ]
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
