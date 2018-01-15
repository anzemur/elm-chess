module Update exposing (..)

import Model exposing (Model, Msg)
import Moves exposing (returnPossibleMovesHighlighted, searchSquare)
import Types exposing (Board, HighlightType, Square)


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
    let
      updateBoard : (Square -> Square) -> List (List Square)
      updateBoard mapper =
        List.map
            (\rowlist ->
                List.map
                    (\square -> mapper square)
                    rowlist
            )
            board.board
    in
    case clickType of
        Model.FirstClick ->
            { board
                | board = updateBoard  (\square ->
                                if square.pos == (row, col) && square.highlightType /= Types.ChosenSquare then
                                    { square | highlightType = Types.ChosenSquare }
                                else
                                    { square | highlightType = Types.None }
                            )
            }

        Model.MoveFigure ->
            let
                movedSquare =
                    searchSquare board (\square -> square.highlightType == Types.ChosenSquare)
            in
            { board
                | board = updateBoard  (\square ->
                                    if square.pos == (row, col) then
                                        { square | highlightType = Types.None, figure = movedSquare.figure }
                                    else if square.pos == movedSquare.pos then
                                        { square | highlightType = Types.None, figure = Types.Figure Types.Empty Types.NoColor "" }
                                    else
                                        { square | highlightType = Types.None }
                                )
            }
