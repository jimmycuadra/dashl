module Dashboard exposing (..)

import Date
import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Timer
import Timer.Subscriptions
import Timer.Update
import Timer.View
import Weather
import Weather.Subscriptions
import Weather.Update
import Weather.View


type alias Config =
    { timer : TimerConfig
    , weather : WeatherConfig
    }


type alias TimerConfig =
    { name : String
    , time : String
    }


type alias WeatherConfig =
    { darkSkyApiKey : String
    , latitude : String
    , longitude : String
    , name : String
    }


init : Config -> ( Model, Cmd Msg )
init config =
    let
        model =
            { timer =
                { currentTime = 0
                , eventName = config.timer.name
                , eventTime =
                    (Date.toTime
                        (Date.fromString config.timer.time |> Result.withDefault (Date.fromTime 0))
                    )
                }
            , weather =
                { darkSkyApiKey = config.weather.darkSkyApiKey
                , forecasts = []
                , latitude = config.weather.latitude
                , longitude = config.weather.longitude
                , name = config.weather.name
                }
            }
    in
        model ! [ Cmd.map TimerMsg Timer.init, Cmd.map WeatherMsg Weather.init ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map TimerMsg (Timer.Subscriptions.subscriptions model.timer)
        , Sub.map WeatherMsg (Weather.Subscriptions.subscriptions model.weather)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimerMsg msg ->
            let
                ( timerModel, cmd ) =
                    Timer.Update.update msg model.timer
            in
                ( { model | timer = timerModel }, cmd )

        WeatherMsg msg ->
            let
                ( weatherModel, cmd ) =
                    Weather.Update.update msg model.weather
            in
                ( { model | weather = weatherModel }, cmd )


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ Html.map (\msg -> TimerMsg msg) (Timer.View.view model.timer)
        , Html.map (\msg -> WeatherMsg msg) (Weather.View.view model.weather)
        ]
