module Moves exposing (..)
import Types exposing (..)
import Tuple exposing (first, second, mapFirst, mapSecond)

-- All the moves for certain types of figures

type alias Vector =
  { position : Square
  , next : Square -> Square
  , isBlocked : Bool
  , blockIn : Int
  }

calcNext : Vector -> Board -> Vector
calcNext vector board =
  let
    nextSquare row col = searchSquare board (\square -> square.pos == (row, col))
  in
  case (vector.next vector.position).pos of
    (row, col) -> if row > 7 || row < 0 || col > 7 || col < 0 || vector.blockIn == 0 || (nextSquare row col).figure.color == vector.position.figure.color then
                    {vector | position = vector.next vector.position, isBlocked = True}
                  else if (nextSquare row col).figure.color /= vector.position.figure.color && (nextSquare row col).figure.color /= NoColor then
                    {vector | position = vector.next vector.position, blockIn = 0}
                  else
                    {vector | position = vector.next vector.position, blockIn = vector.blockIn - 1}

searchSquare : Board -> (Square -> Bool) -> Square
searchSquare board check =
  let
    res = List.filterMap (\square -> if check square then
                                        Just (square)
                                     else
                                        Nothing)
      (List.concatMap (\ a -> a) board.board)
  in
    case res of
      h::t -> h
      _ -> {highlightType = None ,pos = (0,0), figure = {figureType = Empty, color = NoColor, img_src = ""}}

moves =
    1

returnPossibleMovesHighlighted : Board -> Board
returnPossibleMovesHighlighted board =
  let
      vectors : Square -> List Vector
      vectors square =
        let
          makeVectors : Int -> List (Int -> Int -> Vector)
          makeVectors n = List.repeat n (\a b -> {blockIn = -1, isBlocked = False, position = square, next = \square -> {square | pos = (first square.pos + a, second square.pos + b)}})
          rowSelect = (Tuple.first square.pos)
          colSelect = (Tuple.second square.pos)
        
          forwardDistance =
            case square.figure.color of
              Black -> if rowSelect == 1 then
                      2
                    else
                      1
              White -> if rowSelect == 6 then
                      2
                    else
                      1
              _ -> 0

          forwardVector n =
            [{blockIn = forwardDistance, isBlocked = False, position = square
                      , next = \square -> if (searchSquare board (\sq -> sq.pos == mapFirst (\x -> x+n) square.pos)).figure.color == NoColor then
                                              {square | pos = mapFirst (\x -> x+n) square.pos}
                                          else
                                              square
            }]

          sideVectors row col =
            let
              nextColor = (searchSquare board (\sq -> sq.pos == ((first square.pos) + row, (second square.pos) + col))).figure.color
            in
            [{blockIn = 1, isBlocked = False, position = square
                      , next = \square -> if nextColor /= square.figure.color && nextColor /= NoColor then
                                              {square | pos = ((first square.pos) + row, (second square.pos) + col)}
                                          else
                                              square
            }]
        in
          case square.figure.figureType of
            Rook -> List.map2 (\vector tupl -> vector (first tupl) (second tupl)) (makeVectors 4) [(1,0), (-1,0), (0,1), (0,-1)]
            Bishop -> List.map2 (\vector tupl -> vector (first tupl) (second tupl)) (makeVectors 4) [(1,1), (1,-1), (-1,1), (-1,-1)]
            Queen -> let
                        figura = square.figure
                     in
                     (vectors {square | figure = { figura | figureType = Rook}}) ++ (vectors {square | figure = { figura | figureType = Bishop}})
            Knight -> List.map2 (\vector tupl ->
                                  let
                                    myVector = vector (first tupl) (second tupl)
                                  in
                                  {myVector | blockIn = 1}) (makeVectors 8) [(-2,1), (-1,2), (1,2), (2,1), (2,-1), (1,-2), (-1,-2), (-2,-1)]
            King -> let
                        figura = square.figure
                     in
                     List.map (\vector -> {vector | blockIn = 1}) (vectors {square | figure = { figura | figureType = Queen}})
            Pawn-> case square.figure.color of
                      Black -> (forwardVector 1) ++ (sideVectors 1 1) ++ (sideVectors 1 -1)
                      White -> (forwardVector -1) ++ (sideVectors -1 1) ++ (sideVectors -1 -1)
                      _ -> [{isBlocked = True, position = square, next = \_ -> square, blockIn = -1}]
            _ -> [{isBlocked = True, position = square, next = \_ -> square, blockIn = -1}]




      newBoard : List (List Types.Square)
      newBoard =
        let
          vectorList = vectors (searchSquare board (\square -> square.highlightType == ChosenSquare))

          changeBoard : List (List Types.Square) -> Vector -> List (List Types.Square)
          changeBoard squareList vector=
            if vector.isBlocked == False then
              changeBoard (changeSquare squareList vector) (calcNext vector board)
            else
              squareList

          changeSquare : List (List Types.Square) -> Vector -> List (List Types.Square)
          changeSquare squareList vector =
            List.map (\row -> List.map (\square -> if vector.position.pos == square.pos && square.pos /= (searchSquare board (\square -> square.highlightType == ChosenSquare)).pos then
                                                  {square | highlightType = PossibleMove}
                                               else
                                                  square
                                          ) row) squareList
        in
        List.foldl (\vector board -> changeBoard board vector) board.board vectorList

    in
    {board | board = newBoard}
