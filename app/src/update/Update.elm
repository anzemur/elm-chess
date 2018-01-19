module Update exposing (..)

import Board exposing (createInitialBoard)
import ChessApi exposing (startGameOne)
import Http
import Model exposing (Model, Msg)
import Moves exposing (returnPossibleMovesHighlighted, searchSquare)
import Time
import Types exposing (Board, Game, HighlightType, Square)


-- Update function for the chess game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        moveFigureAiCmd =
            case model.game.gameType of
                Types.PlayerVsAi ->
                    Model.moveFigureAi model.game.gameId

                _ ->
                    Cmd.none
    in
    case msg of
        Model.SquareSelected row col clickType ->
            let
                changePlayer : Types.Color -> Board -> Types.Color
                changePlayer color board =
                    case (searchSquare board (\square -> square.highlightType == Types.SuccessfulMove)).pos of
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

                -- Sends a command if a move happened on the Ai or player side
                moveFigurePlayerCmd =
                    case ( clickType, model.playerColor ) of
                        ( Model.MoveFigure, Types.White ) ->
                            Model.moveFigurePlayerOne model.game.gameId model.selectedSquare ( row, col )

                        _ ->
                            Cmd.none
            in
            ( { model
                | selectedSquare = ( row, col )
                , board = returnPossibleMovesHighlighted highlightBoard
                , playerColor = changePlayer model.playerColor highlightBoard

                -- , helpHighlightPos = ( -1, -1 )
              }
            , moveFigurePlayerCmd
            )

        Model.Highscores (Ok highscores) ->
            ( { model | highscores = highscores }, Cmd.none )

        Model.GameOneStart (Ok game_id) ->
            ( { model | startTime = model.currTime, game = { gameType = Types.PlayerVsAi, gameId = game_id }, board = createInitialBoard, playerColor = Types.White }, Cmd.none )

        Model.MoveFigureAi (Ok move) ->
            let
                _ =
                    Debug.log " " (toString move)
            in
            update (Model.SquareSelected (Tuple.second move.to) (Tuple.first move.to) Model.MoveFigure)
                { model
                    | board =
                        { board =
                            List.indexedMap
                                (\idxRow row ->
                                    if Tuple.second move.from == idxRow then
                                        List.indexedMap
                                            (\idxCol sqr ->
                                                if Tuple.first move.from == idxCol then
                                                    { sqr | highlightType = Types.ChosenSquare, pos = sqr.pos }
                                                else
                                                    sqr
                                            )
                                            row
                                    else
                                        row
                                )
                                model.board.board
                        }
                }

        Model.MoveFigurePlayerOne (Ok result) ->
            let
                _ =
                    Debug.log "MoveFigPlayerOne result" (toString result)
            in
            ( model, moveFigureAiCmd )

        Model.Help ->
            ( model, Model.playerVsAiHelp model.game.gameId )

        Model.PlayerVsAiHelp (Ok move) ->
            let
                _ =
                    Debug.log " " (toString move)
            in
            update (Model.SquareSelected (Tuple.second move.from) (Tuple.first move.from) Model.FirstClick)
                { model | helpHighlightPos = move.to }

        Model.ShowMainMenu ->
            ( { model | route = Model.MainMenu }, Cmd.none )

        Model.ShowHighscoresMenu ->
            ( { model | route = Model.HighscoresMenu }, Model.getHighscores )

        Model.ShowGameTypesMenu ->
            ( { model | route = Model.GameTypeMenu }, Cmd.none )

        Model.ShowGameOverMenu ->
            ( { model | route = Model.GameOverMenu }, Cmd.none )

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
            printErrors e model

        Model.GameOneStart (Err e) ->
            printErrors e model

        Model.MoveFigurePlayerOne (Err e) ->
            printErrors e model

        Model.MoveFigureAi (Err e) ->
            printErrors e model

        Model.PlayerVsAiHelp (Err e) ->
            printErrors e model

        Model.TwoPlayerGame ->
            ( model, Cmd.none )


printErrors e model =
    let
        _ =
            Debug.log "Http error:" e
    in
    ( { model | errors = e :: model.errors }, Cmd.none )


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

        helpHighlightPosReverse =
            ( Tuple.second model.helpHighlightPos, Tuple.first model.helpHighlightPos )
    in
    case clickType of
        Model.FirstClick ->
            { currentBoard
                | board =
                    updateBoard
                        (\square ->
                            if square.pos == ( row, col ) && square.highlightType /= Types.ChosenSquare && model.playerColor == square.figure.color then
                                { square | highlightType = Types.ChosenSquare }
                            else
                                { square | highlightType = Types.None }
                        )
            }

        Model.MoveFigure ->
            let
                movedSquare =
                    searchSquare currentBoard (\square -> square.highlightType == Types.ChosenSquare)
            in
            { currentBoard
                | board =
                    updateBoard
                        (\square ->
                            if square.pos == ( row, col ) then
                                { square | highlightType = Types.SuccessfulMove, figure = movedSquare.figure }
                            else if square.pos == movedSquare.pos then
                                { square | highlightType = Types.None, figure = Types.Figure Types.Empty Types.NoColor "" }
                            else
                                { square | highlightType = Types.None }
                        )
            }
