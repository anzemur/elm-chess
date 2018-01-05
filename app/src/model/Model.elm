module Model exposing (..)

import Board exposing (createInitialBoard)
import Types exposing (Board)


-- Model definition for the chess game


type Msg
    = SquareSelected Int Int


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 ), board = createInitialBoard }, Cmd.none )


type alias Model =
    { selectedSquare : ( Int, Int )
    , board : Board
    }
