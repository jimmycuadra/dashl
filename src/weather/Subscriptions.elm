module Weather.Subscriptions exposing (subscriptions)

import Weather.Types


subscriptions : Weather.Types.Model -> Sub Weather.Types.Msg
subscriptions model =
    Sub.none
