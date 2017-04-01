module Weather.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
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
            , div [ class "row" ]
                [ div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "w-100" ] []
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                , div [ class "col" ]
                    [ h5 [] [ text "Monday, 4/2" ]
                    , p []
                        [ text "69°F high"
                        , br [] []
                        , text "57°F low"
                        ]
                    ]
                ]
            ]
        ]
