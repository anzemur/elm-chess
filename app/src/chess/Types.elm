module Types exposing (..)

-- All the type/type alias definitions are here


type FigureType
    = King
    | Queen
    | Bishop
    | Pawn
    | Rook
    | Knight
    | Empty


type GameType
    = PlayerVsAi
    | PlayerVsPlayer
    | NoGame


type alias Game =
    { gameId : String
    , gameType : GameType
    }


type alias Player =
    {}


type Color
    = Black
    | White
    | NoColor


type HighlightType
    = None
    | PossibleMove
    | ChosenSquare
    | AIRecommmends
    | SuccessfulMove


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
    , color : Color
    , img_src : String
    }
