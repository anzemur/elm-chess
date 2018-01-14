module Update exposing (..)

import Model exposing (Model, Msg)
import Types exposing (Board, HighlightType, Square)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.SquareSelected row col clickType ->
            ( { model | selectedSquare = ( row, col ), board = updateSquareHighlight model.board row col clickType }, Model.getHighscores )

        Model.Highscores (Ok highscores) ->
            ( { model | highscores = highscores }, Cmd.none )

        Model.GameOneStart (Ok game_id) ->
            ( model, Cmd.none )

        -- HTTP ERROR HANDLING
        Model.Highscores (Err e) ->
            let
                _ =
                    Debug.log "highscores get err" e
            in
            ( { model | errors = e :: model.errors }, Cmd.none )

        Model.GameOneStart (Err e) ->
            let
                _ =
                    Debug.log "highscores get err" e
            in
            ( { model | errors = e :: model.errors }, Cmd.none )


updateSquareHighlight : Board -> Int -> Int -> Model.ClickType -> Board
updateSquareHighlight board row col clickType =
    case clickType of
        Model.FirstClick ->
            { board
                | board =
                    List.indexedMap
                        (\rown rowlist ->
                            List.indexedMap
                                (\coln square ->
                                    if row == rown && col == coln then
                                        { square | highlightType = Types.ChosenSquare }
                                    else
                                        { square | highlightType = Types.None }
                                )
                                rowlist
                        )
                        board.board
            }
