module Main exposing (..)

import Dashboard exposing (Flags, Model, Msg, init, subscriptions, update, view)
import Html exposing (programWithFlags)


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
