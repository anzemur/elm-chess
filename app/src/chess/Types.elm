module Types exposing (..)

-- All the type/type alias definitions are here


type FigureType
    = King
    | Queen
    | Bishop
    | Pawn
    | Rook
    | Knight


type Color
    = Black
    | White


type alias Board =
    { board : List (List Square) }


type alias Square =
    { figure : Figure
    , pos : ( Int, Int ) -- (row,col)
    }


type alias Figure =
    { figureType : FigureType
    , pos : ( Int, Int ) -- (row,col)
    , color : Color
    , img_src : String
    }
