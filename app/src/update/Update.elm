module Update exposing (..)

import ChessApi exposing (startGameOne)
import Http
import Model exposing (Model, Msg)
import Moves exposing (returnPossibleMovesHighlighted, searchSquare)
import Time
import Types exposing (Board, Game, HighlightType, Square)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.SquareSelected row col clickType ->
            let
                changePlayer : Types.Color -> Board -> Types.Color
                changePlayer color board =
                    case (searchSquare board (\square -> List.member Types.SuccessfulMove square.highlightType)).pos of
                        ( -1, -1 ) ->
                            color

                        _ ->
                            case color of
                                Types.Black ->
                                    Types.White

                                Types.White ->
                                    Types.Black

                                _ ->
                                    Types.White

                highlightBoard =
                    updateSquareHighlight model row col clickType
            in
            ( { model
                | selectedSquare = ( row, col )
                , board = returnPossibleMovesHighlighted highlightBoard
                , playerColor = changePlayer model.playerColor highlightBoard
              }
            , Cmd.none
            )

        Model.Highscores (Ok highscores) ->
            ( { model | highscores = highscores }, Cmd.none )

        Model.GameOneStart (Ok game_id) ->
            ( { model | startTime = model.currTime, game = { gameType = Types.PlayerVsAi, gameId = game_id } }, Cmd.none )

        Model.ShowMainMenu ->
            ( { model | route = Model.MainMenu }, Cmd.none )

        Model.ShowHighscoresMenu ->
            ( { model | route = Model.HighscoresMenu }, Model.getHighscores )

        Model.ShowGameTypesMenu ->
            ( { model | route = Model.GameTypeMenu }, Cmd.none )

        Model.OnePlayerGame ->
            ( { model | route = Model.GameOne }, Model.startGameOne )

        --Model.TwoPlayerGame ->
        --( { model | route = Model.Game }, Model.startGameOne )
        Model.Tick newTime ->
            ( { model
                | currTime = newTime
                , score =
                    if model.startTime > 0 then
                        round (Time.inSeconds newTime - Time.inSeconds model.startTime)
                    else
                        model.score
              }
            , Cmd.none
            )

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


updateSquareHighlight : Model -> Int -> Int -> Model.ClickType -> Board
updateSquareHighlight model row col clickType =
    let
        currentBoard =
            model.board

        updateBoard : (Square -> Square) -> List (List Square)
        updateBoard mapper =
            List.map
                (\rowlist ->
                    List.map
                        (\square -> mapper square)
                        rowlist
                )
                model.board.board
    in
    case clickType of
        Model.FirstClick ->
            { currentBoard
                | board =
                    updateBoard
                        (\square ->
                            if square.pos == ( row, col ) && not (List.member Types.ChosenSquare square.highlightType) && model.playerColor == square.figure.color then
                                { square | highlightType = Types.ChosenSquare::square.highlightType }
                            else
                                { square | highlightType = [Types.None] }
                        )
            }

        Model.MoveFigure ->
            let
                movedSquare =
                    searchSquare currentBoard (\square -> List.member Types.ChosenSquare square.highlightType)
            in
            { currentBoard
                | board =
                    updateBoard
                        (\square ->
                            if square.pos == ( row, col ) then
                                { square | highlightType = [Types.SuccessfulMove], figure = movedSquare.figure }
                            else if square.pos == movedSquare.pos then
                                { square | highlightType = [Types.None], figure = Types.Figure Types.Empty Types.NoColor "" }
                            else
                                { square | highlightType = [Types.None] }
                        )
            }
