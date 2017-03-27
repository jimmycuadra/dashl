module Main exposing (..)

import Dashboard
import Html exposing (program)


main : Program Never Dashboard.Model Dashboard.Msg
main =
    program
        { init = Dashboard.init
        , view = Dashboard.view
        , update = Dashboard.update
        , subscriptions = Dashboard.subscriptions
        }
