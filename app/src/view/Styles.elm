module Styles exposing (..)

import Html.Attributes exposing (selected, style)


squareStyle selected isBlack =
    style
        [ ( "display", "inline-block" )
        , ( "height", "60px" )
        , ( "width", "60px" )
        , ( "border-style", "solid" )
        , ( "border-width", "1px" )
        , ( "background"
          , if selected then
                "cyan"
            else if isBlack then
                "rgb(192, 152, 31)"
            else
                "rgba(192, 152, 31,0.5)"
          )
        ]
