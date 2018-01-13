module Model exposing (..)

import Board exposing (createInitialBoard)
import ChessApi
import Http
import Types exposing (Board, PlayerScore)


-- Model definition for the chess game


type ClickType
    = FirstClick


type Msg
    = SquareSelected Int Int ClickType
    | Highscores (Result Http.Error (List PlayerScore))


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 ), errors = [], board = createInitialBoard, highscores = [] }, getHighscores )


type alias Model =
    { selectedSquare : ( Int, Int )
    , board : Board
    , highscores : List PlayerScore
    , errors : List Http.Error
    }


getHighscores =
    Http.send Highscores ChessApi.getHighscore
