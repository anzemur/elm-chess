module Model exposing (..)

import Board exposing (createInitialBoard)
import ChessApi
import Http
import Time exposing (Time, second)
import Types exposing (Board, Color, Game, PlayerScore)


-- Model definition for the chess game


type ClickType
    = FirstClick
    | MoveFigure


type Route
    = MainMenu
    | HighscoresMenu
    | GameTypeMenu
    | GameOne
    | GameTwo


type Msg
    = SquareSelected Int Int ClickType
    | Highscores (Result Http.Error (List PlayerScore))
    | GameOneStart (Result Http.Error String)
    | OnePlayerGame
    | TwoPlayerGame
    | ShowMainMenu
    | ShowGameTypesMenu
    | ShowHighscoresMenu
    | Tick Time


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 )
      , playerColor = Types.White
      , errors = []
      , game = { gameType = Types.NoGame, gameId = "" }
      , board = createInitialBoard
      , highscores = []
      , route = MainMenu
      , currTime = 0
      , startTime = 0
      , score = 0
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
    , currTime : Time
    , startTime : Time
    , score : Int
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- Returns highscores


getHighscores =
    Http.send Highscores ChessApi.getHighscore



-- Starts a game against a computer


startGameOne =
    Http.send GameOneStart ChessApi.startGameOne



-- moveFigurePlayerOne = Http.send
