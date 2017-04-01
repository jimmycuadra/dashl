module Weather.View exposing (view)

import Date exposing (Day(..), Month(..))
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
            List.concat (List.indexedMap forecastWithBreakerView forecasts)

        Nothing ->
            []


forecastWithBreakerView : Int -> Weather.Types.Forecast -> List (Html Weather.Types.Msg)
forecastWithBreakerView index forecast =
    let
        breaker =
            if (index /= 0) && (index % 4 == 0) then
                [ div [ class "w-100" ] [] ]
            else
                []
    in
        breaker ++ [ forecastView forecast ]


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
            let
                date =
                    Date.fromTime (toFloat (time * 1000))

                month =
                    Date.month date

                day =
                    Date.dayOfWeek date

                dayNumber =
                    Date.day date
            in
                text <| (fullDay day) ++ ", " ++ (monthNumber month) ++ "/" ++ (toString dayNumber)

        Nothing ->
            text ""


fullDay : Day -> String
fullDay day =
    case day of
        Mon ->
            "Monday"

        Tue ->
            "Tuesday"

        Wed ->
            "Wednesday"

        Thu ->
            "Thursday"

        Fri ->
            "Friday"

        Sat ->
            "Saturday"

        Sun ->
            "Sunday"


monthNumber : Month -> String
monthNumber month =
    case month of
        Jan ->
            "1"

        Feb ->
            "2"

        Mar ->
            "3"

        Apr ->
            "4"

        May ->
            "5"

        Jun ->
            "6"

        Jul ->
            "7"

        Aug ->
            "8"

        Sep ->
            "9"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


forecastTemperatureView : Maybe Float -> String -> Html Weather.Types.Msg
forecastTemperatureView maybeTemperature suffix =
    case maybeTemperature of
        Just temperature ->
            text ((toString temperature) ++ suffix)

        Nothing ->
            text ""
