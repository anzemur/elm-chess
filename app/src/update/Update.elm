module Update exposing (..)

import Model exposing (Model, Msg)
import Types exposing (Board, HighlightType, Square)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.SquareSelected row col _ ->
            ( { model | selectedSquare = ( row, col ), board = updateSquareHighlight model.board msg }, Cmd.none )


updateSquareHighlight : Board -> Msg -> Board
updateSquareHighlight board msg =
    case msg of
        Model.SquareSelected row col Model.FirstClick ->
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
