module Weather.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData)
import Weather.Types


view : Weather.Types.Model -> Html Weather.Types.Msg
view model =
    div [ class "row widget" ]
        [ div [ class "col justify-content-center" ]
            [ div [ class "row" ]
                [ div [ class "col" ]
                    [ h1 []
                        [ span [ class "widget-subject" ] [ text model.name ]
                        , text " weather"
                        ]
                    ]
                ]
            , div [ class "row" ] (renderDarkSkyData model.darkSkyData)
            ]
        ]



-- private


renderDarkSkyData : WebData Weather.Types.DarkSkyData -> List (Html Weather.Types.Msg)
renderDarkSkyData remoteDarkSkyData =
    case remoteDarkSkyData of
        RemoteData.NotAsked ->
            []

        RemoteData.Loading ->
            []

        RemoteData.Failure error ->
            []

        RemoteData.Success data ->
            renderDaily data.daily


renderDaily : Maybe Weather.Types.Daily -> List (Html Weather.Types.Msg)
renderDaily maybeDaily =
    case maybeDaily of
        Just daily ->
            renderForecasts daily.data

        Nothing ->
            []


renderForecasts : Maybe (List Weather.Types.Forecast) -> List (Html Weather.Types.Msg)
renderForecasts maybeList =
    case maybeList of
        Just forecasts ->
            List.map forecastView forecasts

        Nothing ->
            []


forecastView : Weather.Types.Forecast -> Html Weather.Types.Msg
forecastView forecast =
    div [ class "col" ]
        [ h5 [] [ forecastTimeView forecast.time ]
        , p []
            [ forecastTemperatureView forecast.temperatureMax "°F high"
            , br [] []
            , forecastTemperatureView forecast.temperatureMin "°F low"
            ]
        ]


forecastTimeView : Maybe Int -> Html Weather.Types.Msg
forecastTimeView maybeTime =
    case maybeTime of
        Just time ->
            text (toString time)

        Nothing ->
            text ""


forecastTemperatureView : Maybe Float -> String -> Html Weather.Types.Msg
forecastTemperatureView maybeTemperature suffix =
    case maybeTemperature of
        Just temperature ->
            text ((toString temperature) ++ suffix)

        Nothing ->
            text ""
