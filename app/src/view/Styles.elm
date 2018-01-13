module Styles exposing (..)

import Html.Attributes exposing (selected, style)
import Types


squareStyle selected isBlack =
  let
    squareColor =
      case selected of
        Types.None -> if isBlack then
          "rgb(192, 152, 31)"
          else
            "rgba(192, 152, 31,0.5)"
        Types.ChosenSquare -> "cyan"
        Types.PossibleMove -> "blue"
        _ -> "black"
  in
    style
        [ ( "display", "inline-block" )
        , ( "height", "60px" )
        , ( "width", "60px" )
        , ( "border-style", "solid" )
        , ( "border-width", "1px" )
        , ( "background"
          , squareColor
          )
        ]


mainViewStyle =
    style
        [ ( "display", "inline-block" )
        , ( "margin", "10px" )
        ]


highscoresStyle =
    style
        [ ( "border-width", "1px" )
        , ( "border-style", "solid" )
        ]
