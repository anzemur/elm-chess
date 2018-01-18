module GameBoard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (figureImgStyle, gameBoardStyle, squareStyle)
import Types exposing (Board, Figure, Square)


view : Model -> Html Msg
view model =
    div [ Styles.gameBoardStyle ]
        [ div [ Styles.chessboardStyle ] (renderBoard model)
        ]



-- Returns a list of Html elements that represent a chessboard


renderBoard : Model -> List (Html Msg)
renderBoard model =
    List.indexedMap (\row boardRow -> renderRow model boardRow row) model.board.board



-- Creates a row for a board


renderRow : Model -> List Square -> Int -> Html Msg
renderRow model boardRow row =
    div [] (List.indexedMap (\col square -> renderSquare model square row col) boardRow)



-- Renders the content of a certain square in a board and send events when clicked


renderSquare : Model -> Square -> Int -> Int -> Html Msg
renderSquare model square row col =
    let
        clickType : Model.ClickType
        clickType =
            if List.member Types.PossibleMove square.highlightType then
                    Model.MoveFigure
            else
                    Model.FirstClick

        setOpacity =
            if String.length square.figure.img_src == 0 then
                "0"
            else
                "1"
    in
    div
        [ squareStyle square.highlightType ((row + col) % 2 == 1)
        , onClick (Model.SquareSelected row col clickType)
        ]
        [ img
            [ src square.figure.img_src
            , figureImgStyle setOpacity
            ]
            []

        --, text (toString (Tuple.first square.pos) ++ " " ++ toString (Tuple.second square.pos))
        ]
