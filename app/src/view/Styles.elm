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
    toString (((squareSizeInt - figureImgSizeInt) * 0.5) * 0.75) ++ "px"


figureImgSize =
    toString figureImgSizeInt ++ "px"


squareStyle selected isBlack =
    let
        squareColor =
            if List.member Types.Check selected then
                "red"
            else if List.member Types.ChosenSquare selected then
                "cyan"
            else if List.member Types.AIRecommmends selected then
                "rgb(155,89,182)"
            else if List.member Types.PossibleMove selected then
                "blue"
            else if List.member Types.SuccessfulMove selected then
                "limegreen"
            else if List.member Types.None selected then
                if isBlack then
                    "rgb(192, 152, 31)"
                else
                    "rgba(192, 152, 31,0.5)"
            else
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


chessboardStyle =
    style
        [ ( "margin-top", "2px" ) ]


chessboardStyleTwo =
    style
        [ ( "margin-top", "60px" ) ]


gameBoardStyle =
    style
        [ ( "position", "absolute" )
        , ( "left", "0px" )
        , ( "top", "0px" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        , ( "background-image", "url(\"assets/other/BackgroundBlue.png\")" )
        , ( "background-size", "cover" )
        , ( "background-repeat", "no-repeat" )
        , ( "background-position", "center center" )
        , ( "text-align", "center" )
        , ( "color", "white" )
        , ( "font-size", "35px" )
        ]


mainViewStyle =
    style
        [ ( "display", "inline-block" )
        , ( "align-content", "center" )
        , ( "background-image", "url(\"assets/other/BackgroundBlue.png\")" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        ]


highscoresStyle =
    style
        [ ( "position", "absolute" )
        , ( "left", "0px" )
        , ( "top", "0px" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        , ( "background-image", "url(\"assets/other/Background.png\")" )
        , ( "background-size", "cover" )
        , ( "background-repeat", "no-repeat" )
        , ( "background-position", "center center" )
        , ( "text-align", "center" )
        , ( "color", "white" )
        , ( "font-size", "40px" )
        ]


mainMenuStyle =
    style
        [ ( "position", "absolute" )
        , ( "left", "0px" )
        , ( "top", "0px" )
        , ( "width", "100%" )
        , ( "height", "100%" )
        , ( "background-image", "url(\"assets/other/Background.png\")" )
        , ( "background-size", "cover" )
        , ( "background-repeat", "no-repeat" )
        , ( "background-position", "center center" )
        , ( "text-align", "center" )
        ]
