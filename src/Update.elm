module Update exposing (..)

import Model exposing (Model)
import Time exposing (Time)


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | currentTime = Just time }, Cmd.none )
