module GameBoard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import List
import Model exposing (Model, Msg)
import Styles exposing (squareStyle)


view : Model -> Html Msg
view model =
    div [] (List.map (renderRow model) (List.range 0 7))



-- renderBoard : Model -> Html Msg
-- renderBoard model =
--     List.map (\a -> a) [0..2]


renderRow : Model -> Int -> Html Msg
renderRow model row =
    div [] (List.map (renderSquare model row) (List.range 0 7))


renderSquare : Model -> Int -> Int -> Html Msg
renderSquare model row col =
    div [ squareStyle ] [ text (toString row ++ " " ++ toString col) ]
