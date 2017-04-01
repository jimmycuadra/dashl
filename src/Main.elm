module Main exposing (..)

import Dashboard exposing (Config, init, subscriptions, update, view)
import Model exposing (Model)
import Msg exposing (Msg)
import Html exposing (programWithFlags)


main : Program Config Model Msg
main =
    programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
