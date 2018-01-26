module GameBoardTwo exposing (..)

import GameBoard exposing (renderBoard)
import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (figureImgStyle, gameBoardStyle, squareStyle)
import Time
import Types exposing (Board, Figure, Square)


view : Model -> Html Msg
view model =
    div [ Styles.gameBoardStyle ]
        [ div [ Styles.chessboardStyleTwo ] (renderBoard model)
        , button
            [ style
                [ ( "background", "url(\"assets/buttons/QuitGame.png\")" )
                , ( "width", "200px" )
                , ( "height", "50px" )
                ]
            , onClick Model.QuitGame
            ]
            []
        ]
