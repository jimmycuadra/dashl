module Main exposing (..)

import Dashboard exposing (init, subscriptions, view)
import Html exposing (program)
import Model exposing (Model)
import Update exposing (Msg, update)


main : Program Never Model Msg
main =
    program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
