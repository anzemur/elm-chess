module Styles exposing (..)

import Html.Attributes exposing (selected, style)
import Types


squareSizeInt =
    80


squareSize =
    toString squareSizeInt ++ "px"


figureImgSizeInt =
    squareSizeInt * 0.5


figureMargin =
    toString (((squareSizeInt - figureImgSizeInt) * 0.5) * 0.9) ++ "px"


figureImgSize =
    toString figureImgSizeInt ++ "px"


squareStyle selected isBlack =
    let
        squareColor =
            case selected of
                Types.None ->
                    if isBlack then
                        "rgb(192, 152, 31)"
                    else
                        "rgba(192, 152, 31,0.5)"

                Types.ChosenSquare ->
                    "cyan"

                Types.PossibleMove ->
                    "blue"

                _ ->
                    "black"
    in
    style
        [ ( "display", "inline-block" )
        , ( "height", squareSize )
        , ( "width", squareSize )
        , ( "border-style", "solid" )
        , ( "border-width", "1px" )
        , ( "background"
          , squareColor
          )
        ]


figureImgStyle setOpacity =
    style
        [ ( "height", figureImgSize )
        , ( "width", figureImgSize )
        , ( "opacity", setOpacity )
        , ( "margin", figureMargin )
        ]


gameBoardStyle =
    style []


mainViewStyle =
    style
        [ ( "display", "inline-block" )
        , ( "margin", "10px" )

        --  , ( "width", "50%" )
        , ( "align-content", "center" )
        ]


highscoresStyle =
    style
        [ ( "border-width", "1px" )
        , ( "border-style", "solid" )
        ]
