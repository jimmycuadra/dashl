module Dashboard exposing (..)

import Countdown exposing (Remaining)
import Date
import Html exposing (..)
import Html.Attributes exposing (class)
import Task
import Time exposing (Time)


-- MODEL


type alias Model =
    { description : String
    , currentTime : Maybe Time
    , eventTime : Time
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        "London trip"
        Nothing
        (Date.toTime (Date.fromString "23 Apr 2017 00:00:00 GMT-0700" |> Result.withDefault (Date.fromTime 0)))
    , getTime
    )


getTime : Cmd Msg
getTime =
    Task.perform Tick Time.now



-- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | currentTime = Just time }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        remaining =
            timeRemaining model
    in
        div [ class "container-fluid", class "full-height" ]
            [ div [ class "row", class "align-items-center", class "full-height" ]
                [ div [ class "col", class "text-center" ]
                    [ eventDescriptionView model.description
                    , timeRemainingView remaining
                    ]
                ]
            ]


eventDescriptionView : String -> Html Msg
eventDescriptionView description =
    div [ class "row", class "event-description" ]
        [ div [ class "col" ]
            [ h1 [ class "display-1" ]
                [ span [] [ text description ]
                , text " in"
                ]
            ]
        ]


timeRemainingView : Remaining -> Html Msg
timeRemainingView remaining =
    div [ class "row" ]
        [ timeRemainingComponentView remaining.days "d"
        , timeRemainingComponentView remaining.hours "h"
        , timeRemainingComponentView remaining.minutes "m"
        , timeRemainingComponentView remaining.seconds "s"
        ]


timeRemainingComponentView : Int -> String -> Html Msg
timeRemainingComponentView duration suffix =
    div [ class "col" ]
        [ h1 [ class "display-2" ]
            [ span [ class "pod" ] [ text <| toString duration ++ suffix ]
            ]
        ]



-- HELPERS


timeRemaining : Model -> Remaining
timeRemaining model =
    case model.currentTime of
        Just currentTime ->
            model.eventTime - currentTime |> Time.inSeconds |> Countdown.remaining

        Nothing ->
            Countdown.unknown
