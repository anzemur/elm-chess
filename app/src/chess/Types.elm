module Types exposing (..)

-- All the type/type alias definitions are here


type FigureType
    = King
    | Queen
    | Bishop
    | Pawn
    | Rook
    | Knight


type alias Board =
    { board : List (List Figure) }


type alias Figure =
    { figureType : FigureType
    , pos : ( Int, Int ) -- (row,col)
    , color : Boolean
    }
