module GameBoardTwo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (figureImgStyle, gameBoardStyle, squareStyle)
import Time
import Types exposing (Board, Figure, Square)
import GameBoard exposing (renderBoard)

view : Model -> Html Msg
view model =
    div [ Styles.gameBoardStyle ]
        [ div [ Styles.chessboardStyle ] (renderBoard model)
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/QuitGame.png\")" )
                , ( "width", "200px" )
                , ( "height", "50px" )
                ]
            , onClick Model.ShowMainMenu
            ]
            []
        ]
