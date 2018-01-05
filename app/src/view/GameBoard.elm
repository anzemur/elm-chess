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
    List.map2 (\row boardRow -> renderRow model boardRow row) (List.range 0 7) model.board.board



-- Creates a row for a board


renderRow : Model -> List Square -> Int -> Html Msg
renderRow model boardRow row =
    div [] (List.map2 (\col square -> renderSquare model square row col) (List.range 0 7) boardRow)



-- Renders the content of a certain square in a board and send events when clicked


renderSquare : Model -> Square -> Int -> Int -> Html Msg
renderSquare model square row col =
    let
        selectedField =
            case model.selectedSquare of
                ( a, b ) ->
                    if a == row && b == col then
                        True
                    else
                        False
    in
    div
        [ squareStyle selectedField ((row + col) % 2 == 1)
        , onClick (Model.SquareSelected row col)
        ]
        [ img
            [ src square.figure.img_src
            , style
                [ ( "height", "35px" )
                , ( "width", "35px" )
                ]
            ]
            []
        , text (toString row ++ " " ++ toString col)
        ]
