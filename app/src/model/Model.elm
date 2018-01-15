module Model exposing (..)

import Board exposing (createInitialBoard)
import ChessApi
import Http
import Types exposing (Board, Color, Game, PlayerScore)


-- Model definition for the chess game


type ClickType
    = FirstClick
    | MoveFigure


type Route
    = MainMenu
    | HighscoresMenu
    | GameTypeMenu
    | Game


type Msg
    = SquareSelected Int Int ClickType
    | Highscores (Result Http.Error (List PlayerScore))
    | GameOneStart (Result Http.Error String)
    | OnePlayerGame
    | TwoPlayerGame
    | ShowMainMenu
    | ShowGameTypesMenu
    | ShowHighscoresMenu


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 )
      , playerColor = Types.White
      , errors = []
      , game = { gameType = Types.NoGame, gameId = "" }
      , board = createInitialBoard
      , highscores = []
      , route = MainMenu
      }
    , getHighscores
    )


type alias Model =
    { selectedSquare : ( Int, Int )
    , playerColor : Color
    , board : Board
    , game : Game
    , highscores : List PlayerScore
    , errors : List Http.Error
    , route : Route
    }



-- Returns highscores


getHighscores =
    Http.send Highscores ChessApi.getHighscore



-- Starts a game against a computer


startGameOne =
    Http.send GameOneStart ChessApi.startGameOne



-- moveFigurePlayerOne = Http.send
