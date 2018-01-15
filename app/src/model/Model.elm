module Model exposing (..)

import Board exposing (createInitialBoard)
import ChessApi
import Http
import Types exposing (Board, Game, PlayerScore)


-- Model definition for the chess game


type ClickType
    = FirstClick
    | MoveFigure


type Msg
    = SquareSelected Int Int ClickType
    | Highscores (Result Http.Error (List PlayerScore))
    | GameOneStart (Result Http.Error String)
    | OnePlayerGame
    | TwoPlayerGame


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 )
      , errors = []
      , game = { gameType = Types.NoGame, gameId = "" }
      , board = createInitialBoard
      , highscores = []
      }
    , getHighscores
    )


type alias Model =
    { selectedSquare : ( Int, Int )
    , board : Board
    , game : Game
    , highscores : List PlayerScore
    , errors : List Http.Error
    }



-- Returns highscores


getHighscores =
    Http.send Highscores ChessApi.getHighscore



-- Starts a game against a computer


startGameOne =
    Http.send GameOneStart ChessApi.startGameOne



-- moveFigurePlayerOne = Http.send
