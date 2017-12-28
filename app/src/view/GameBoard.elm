module GameBoard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (squareStyle)
import Svg.Attributes exposing (visibility)


view : Model -> Html Msg
view model =
    div [] (renderBoard model)



-- Returns a list of Html elements that represnt a chessboard


renderBoard : Model -> List (Html Msg)
renderBoard model =
    List.map (renderRow model) (List.range 0 7)



-- Creates a row for a board


renderRow : Model -> Int -> Html Msg
renderRow model row =
    div [] (List.map (renderSquare model row) (List.range 0 7))



-- Renders the content of a certain square in a board and send events when clicked


renderSquare : Model -> Int -> Int -> Html Msg
renderSquare model row col =
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
        [ squareStyle selectedField
        , onClick (Model.SquareSelected row col)
        ]
        [ img
            [ src "assets/king_black.svg"
            , style
                [ ( "visibility"
                  , if selectedField then
                        "visible"
                    else
                        "hidden"
                  )
                , ( "height", "20px" )
                , ( "width", "20px" )
                ]
            ]
            []
        , text (toString row ++ " " ++ toString col)
        ]
