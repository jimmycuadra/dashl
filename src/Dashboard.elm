module Dashboard exposing (..)

import Date
import Html exposing (..)
import Html.Attributes exposing (class)
import Timer
import Weather


type alias Flags =
    { eventName : String
    , eventTime : String
    , openWeatherMapApiKey : String
    }


type alias Model =
    { timer : Timer.Model
    , weather : Weather.Model
    }


type Msg
    = Timer Timer.Msg
    | Weather Weather.Msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { timer =
                { currentTime = Nothing
                , eventName = flags.eventName
                , eventTime =
                    (Date.toTime
                        (Date.fromString flags.eventTime |> Result.withDefault (Date.fromTime 0))
                    )
                }
            , weather =
                { openWeatherMapApiKey = flags.openWeatherMapApiKey
                }
            }
    in
        model ! [ Cmd.map Timer Timer.init ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Sub.map Timer (Timer.subscriptions model.timer) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Timer msg ->
            let
                ( timerModel, cmd ) =
                    (Timer.update msg model.timer)
            in
                ( { model | timer = timerModel }, Cmd.map Timer cmd )

        Weather msg ->
            let
                ( weatherModel, cmd ) =
                    (Weather.update msg model.weather)
            in
                ( { model | weather = weatherModel }, Cmd.map Weather cmd )


view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col" ]
            [ (Html.map (\msg -> Timer msg) (Timer.view model.timer))
            ]
        , div [ class "col" ]
            [ (Html.map (\msg -> Weather msg) (Weather.view model.weather))
            ]
        ]
