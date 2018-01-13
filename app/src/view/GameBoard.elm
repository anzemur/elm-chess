module GameBoard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (squareStyle)
import Types exposing (Board, Figure, Square)


view : Model -> Html Msg
view model =
    div [] (renderBoard model)



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
    div
        [ squareStyle square.highlightType ((row + col) % 2 == 1)
        , onClick (Model.SquareSelected row col Model.FirstClick)
        ]
        [ img
            [ src square.figure.img_src
            , style
                [ ( "height", "35px" )
                , ( "width", "35px" )
                ]
            ]
            []
        , text (toString (Tuple.first square.pos) ++ " " ++ toString (Tuple.second square.pos))
        ]
