module Styles exposing (..)

import Html.Attributes exposing (selected, style)


squareStyle selected =
    style
        [ ( "display", "inline-block" )
        , ( "height", "60px" )
        , ( "width", "60px" )
        , ( "border-style", "solid" )
        , ( "border-width", "1px" )
        , ( "background"
          , if selected then
                "cyan"
            else
                "white"
          )
        ]
