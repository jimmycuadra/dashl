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
    , openWeatherApiKey : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        "London trip"
        Nothing
        (Date.toTime (Date.fromString "23 Apr 2017 00:00:00 GMT-0700" |> Result.withDefault (Date.fromTime 0)))
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
