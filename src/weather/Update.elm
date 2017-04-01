module Weather.Update exposing (update, fetchForecasts)

import Http
import Json.Decode exposing (nullable, string)
import Json.Decode.Pipeline exposing (decode, optional)
import Msg exposing (Msg(WeatherMsg))
import RemoteData
import Weather.Types


update : Weather.Types.Msg -> Weather.Types.Model -> ( Weather.Types.Model, Cmd Msg )
update msg model =
    case msg of
        Weather.Types.RenderWeather response ->
            { model | darkSkyData = response } ! []


fetchForecasts : Cmd Weather.Types.Msg
fetchForecasts =
    Http.get "http://localhost:3000/forecast" forecastsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Weather.Types.RenderWeather



-- private


forecastsDecoder : Json.Decode.Decoder Weather.Types.DarkSkyData
forecastsDecoder =
    decode Weather.Types.DarkSkyData
        |> optional "daily" (nullable dailyDecoder) Nothing


dailyDecoder : Json.Decode.Decoder Weather.Types.Daily
dailyDecoder =
    decode Weather.Types.Daily
        |> optional "data" (nullable (Json.Decode.list forecastDecoder)) Nothing


forecastDecoder : Json.Decode.Decoder Weather.Types.Forecast
forecastDecoder =
    decode Weather.Types.Forecast
        |> optional "time" (nullable string) Nothing
        |> optional "temperatureMax" (nullable string) Nothing
        |> optional "temperatureMin" (nullable string) Nothing
