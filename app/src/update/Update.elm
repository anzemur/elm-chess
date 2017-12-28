module Update exposing (..)

import Model exposing (Model, Msg)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.SquareSelected row col ->
            ( { model | selectedSquare = ( row, col ) }, Cmd.none )
