module Weather exposing (Model, Msg, update, view)

import Html exposing (..)


type alias Model =
    { openWeatherMapApiKey : String
    }


type Msg
    = WantWeather


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WantWeather ->
            model ! []


view : Model -> Html Msg
view model =
    div [] []



-- private
