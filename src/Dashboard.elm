module Dashboard exposing (..)

import Date
import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Task
import Time exposing (Time)
import Timer
import Update exposing (Msg)
import Weather


type alias Flags =
    { eventName : String
    , eventTime : String
    , openWeatherMapApiKey : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        Nothing
        flags.eventName
        (Date.toTime (Date.fromString flags.eventTime |> Result.withDefault (Date.fromTime 0)))
        flags.openWeatherMapApiKey
    , getTime
    )


getTime : Cmd Msg
getTime =
    Task.perform Update.Tick Time.now



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Update.Tick



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col" ] (Timer.view model)
        , div [ class "col" ] (Weather.view model)
        ]
