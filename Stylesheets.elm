port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import CssMain


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "dist/css/main.css", Css.File.compile [ CssMain.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
