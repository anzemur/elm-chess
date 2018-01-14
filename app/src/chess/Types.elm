module Types exposing (..)

-- All the type/type alias definitions are here


type FigureType
    = King
    | Queen
    | Bishop
    | Pawn
    | Rook
    | Knight



-- | Nothing


type Color
    = Black
    | White


type HighlightType
    = None
    | PossibleMoves
    | ChosenSquare
    | AIRecommmends


type alias PlayerScore =
    { name : String
    , score_out : String
    }


type alias Board =
    { board : List (List Square) }


type alias Square =
    { figure : Figure
    , highlightType : HighlightType
    , pos : ( Int, Int ) -- (row,col)
    }


type alias Figure =
    { figureType : FigureType
    , pos : ( Int, Int ) -- (row,col)
    , color : Color
    , img_src : String
    }
