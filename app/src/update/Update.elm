module Update exposing (..)

import Model exposing (Model, Msg)
import Types exposing (Square, HighlightType, Board)
import Moves exposing (returnPossibleMovesHighlighted, searchSquare)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.SquareSelected row col clickType ->
            ( { model
                | selectedSquare = ( row, col )
                , board = returnPossibleMovesHighlighted (updateSquareHighlight model.board row col clickType)
              }
            , Cmd.none
            )

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

        _ ->
            ( model, Cmd.none )


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
                                    if row == rown && col == coln && square.highlightType /= Types.ChosenSquare then
                                        { square | highlightType = Types.ChosenSquare }
                                    else
                                        { square | highlightType = Types.None }
                                )
                                rowlist
                        )
                        board.board
            }
        Model.MoveFigure ->
            let
              movedSquare = searchSquare board (\square -> square.highlightType == Types.ChosenSquare)
            in
            { board
                | board =
                    List.indexedMap
                        (\rown rowlist ->
                            List.indexedMap
                                (\coln square ->
                                    if row == rown && col == coln then
                                        { square | highlightType = Types.ChosenSquare, figure = movedSquare.figure }
                                    else if (rown, coln) == movedSquare.pos then
                                        { square | highlightType = Types.None, figure = (Types.Figure Types.Empty Types.NoColor "") }
                                    else
                                        { square | highlightType = Types.None}
                                )
                                rowlist
                        )
                        board.board
            }
