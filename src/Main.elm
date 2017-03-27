module Main exposing (..)

import Dashboard exposing (Flags, init, subscriptions, view)
import Html exposing (programWithFlags)
import Model exposing (Model)
import Update exposing (Msg, update)


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
