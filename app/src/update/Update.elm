module Update exposing (..)

import Model exposing (Model, Msg)
import Types exposing (Square, HighlightType, Board)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
      updateSquareHighlight : Board -> Msg -> Board
      updateSquareHighlight board msg =
        case msg of
            Model.SquareSelected row col Model.FirstClick ->
              {board | board = List.indexedMap (\rown rowlist ->
                    List.indexedMap (\coln square -> if row == rown && col == coln then
                      {square | highlightType = Types.ChosenSquare}
                    else
                      {square | highlightType = Types.None}
                      ) rowlist)
              board.board}
  in

    case msg of
        Model.SquareSelected row col _ ->
            ( { model | selectedSquare = ( row, col ), board = (updateSquareHighlight model.board msg) }, Cmd.none )
