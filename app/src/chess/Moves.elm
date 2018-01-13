module Moves exposing (..)
import Types exposing (..)

-- All the moves for certain types of figures


moves =
    1

returnPossibleMovesHighlighted : Board -> Board
returnPossibleMovesHighlighted board =
  let
      figureMove : Figure -> (Int, Int) -> Square -> Bool
      figureMove figure selectedPosition checkSquare =
        let
          rowSelect = (Tuple.first selectedPosition)
          colSelect = (Tuple.second selectedPosition)
          rowPoss = (Tuple.first checkSquare.pos)
          colPoss = (Tuple.second checkSquare.pos)
          forwardDistance =
            case figure.color of
              Black -> if rowSelect == 1 then
                         2
                       else
                         1
              White -> if rowSelect == 6 then
                         2
                       else
                         1
              _ -> 0
        in
        case figure.figureType of
          Rook -> rowPoss == rowSelect || colPoss == colSelect
          Bishop -> abs (rowPoss - rowSelect) == abs (colPoss - colSelect)
          Queen -> (figureMove {figure | figureType = Rook} selectedPosition checkSquare) || (figureMove {figure | figureType = Bishop} selectedPosition checkSquare)
          Knight -> abs (rowPoss - rowSelect) == 2 && abs (colPoss - colSelect) == 1 ||
                    abs (rowPoss - rowSelect) == 1 && abs (colPoss - colSelect) == 2
          King -> abs (rowPoss - rowSelect) <= 1 && abs (colPoss - colSelect) <= 1
          Pawn-> case figure.color of
                    Black -> (colPoss == colSelect && 0 < rowPoss - rowSelect && rowPoss - rowSelect <= forwardDistance) ||
                             (abs (colPoss - colSelect) == 1 && rowPoss == rowSelect + 1 && checkSquare.figure.color == White)
                    White -> (colPoss == colSelect && 0 > rowPoss - rowSelect && rowSelect - rowPoss <= forwardDistance) ||
                             (abs (colPoss - colSelect) == 1 && rowPoss == rowSelect - 1 && checkSquare.figure.color == Black)
                    _ -> False
          _ -> False

      selected : ((Int, Int), Figure)
      selected =
        let
          res = List.filterMap (\square -> case square.highlightType of
                                        ChosenSquare -> Just (square.pos, square.figure)
                                        _ -> Nothing) (List.concatMap (\ a -> a) board.board)
        in
        case res of
          h::t -> h
          _ -> ((0,0), {figureType = Empty, color = Black, img_src = ""})

      newBoard : List (List Types.Square)
      newBoard =
        List.map (\row -> List.map (\square -> if (figureMove (Tuple.second selected) (Tuple.first selected) square) && square.pos /= (Tuple.first selected) then
          {square | highlightType = PossibleMove}
        else
          square
            ) row) board.board
    in
    {board | board = newBoard}
