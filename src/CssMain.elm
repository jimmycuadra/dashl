module CssMain exposing (CssClasses(..), css)

import Css exposing (..)
import Css.Elements exposing (..)


type CssClasses
    = FullHeight
    | EventDescription
    | Pod


css : Css.Stylesheet
css =
    stylesheet
        [ body
            [ backgroundColor (rgb 37 40 48)
            , color (rgb 207 210 218)
            ]
        , class EventDescription
            [ descendants
                [ span
                    [ color (rgb 28 168 221)
                    ]
                ]
            ]
        , class FullHeight
            [ height (pct 100)
            ]
        , class Pod
            [ backgroundColor (rgb 207 210 218)
            , borderRadius (px 5)
            , color (rgb 37 40 48)
            , display inlineBlock
            , fontFamily monospace
            , minWidth (px 188)
            , padding (px 20)
            , paddingLeft (px 30)
            , paddingRight (px 30)
            ]
        ]
