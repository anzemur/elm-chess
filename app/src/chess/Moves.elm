module Moves exposing (..)
import Types exposing (..)

-- All the moves for certain types of figures


moves =
    1

returnPossibleMovesHighlighted : Board -> Board
returnPossibleMovesHighlighted board =
  let
      figureMove : FigureType -> (Int, Int) -> (Int, Int) -> Bool
      figureMove figure selectedPosition possible =
        case figure of
          Rook -> (Tuple.first possible) == (Tuple.first selectedPosition) || (Tuple.second possible) == (Tuple.second selectedPosition)
          Bishop -> abs ((Tuple.first possible) - (Tuple.first selectedPosition)) == abs ((Tuple.second possible) - (Tuple.second selectedPosition))
          Queen -> (figureMove Rook selectedPosition possible) || (figureMove Bishop selectedPosition possible)
          Knight -> abs ((Tuple.first possible) - (Tuple.first selectedPosition)) == 2 && abs ((Tuple.second possible) - (Tuple.second selectedPosition)) == 1 ||
                    abs ((Tuple.first possible) - (Tuple.first selectedPosition)) == 1 && abs ((Tuple.second possible) - (Tuple.second selectedPosition)) == 2
          King -> abs ((Tuple.first possible) - (Tuple.first selectedPosition)) <= 1 && abs ((Tuple.second possible) - (Tuple.second selectedPosition)) <= 1
          _ -> False

      selected : ((Int, Int), FigureType)
      selected =
        let
          res = List.filterMap (\square -> case square.highlightType of
                                        ChosenSquare -> Just (square.pos, square.figure.figureType)
                                        _ -> Maybe.Nothing) (List.concatMap (\ a -> a) board.board)
        in
        case res of
          h::t -> h
          _ -> ((0,0), Queen)

      newBoard : List (List Types.Square)
      newBoard =
        List.map (\row -> List.map (\square -> if (figureMove (Tuple.second selected) (Tuple.first selected) square.pos) && square.pos /= (Tuple.first selected) then
          {square | highlightType = PossibleMove}
        else
          square
            ) row) board.board
    in
    {board | board = newBoard}
