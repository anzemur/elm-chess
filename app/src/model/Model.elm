module Model exposing (..)

-- Model definition for the chess game


type Msg
    = SquareSelected Int Int


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 ) }, Cmd.none )


type alias Model =
    { selectedSquare : ( Int, Int ) }
