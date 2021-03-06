module Update exposing (..)

import Board exposing (createInitialBoard)
import ChessApi exposing (moveFigureAi, startGameOne)
import Http
import Model exposing (Model, Msg)
import Moves exposing (markCheck, returnPossibleMovesHighlighted, searchSquare)
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

                switchColor =
                    case model.playerColor of
                        Types.White ->
                            Types.Black

                        Types.Black ->
                            Types.White

                        _ ->
                            Types.NoColor

                highlightBoard : Board
                highlightBoard =
                    markCheck (updateSquareHighlight model row col clickType) switchColor

                -- Sends a command if a move happened on the Ai or player side
                moveFigurePlayerCmd =
                    case ( clickType, model.playerColor ) of
                        ( Model.MoveFigure, Types.White ) ->
                            Cmd.batch
                                [ Model.playervsAiCheckmateCheck model.game.gameId
                                , Model.moveFigurePlayerOne model.game.gameId model.selectedSquare ( row, col )
                                , Model.playervsAiCheckmateCheck model.game.gameId
                                ]

                        _ ->
                            Cmd.none
            in
            ( { model
                | selectedSquare = ( row, col )
                , board = returnPossibleMovesHighlighted highlightBoard
                , playerColor = changePlayer model.playerColor highlightBoard
                , helpHighlightPos = ( -1, -1 )
              }
            , moveFigurePlayerCmd
            )

        Model.SendCheckmateCheck ->
            ( model, Model.playervsAiCheckmateCheck model.game.gameId )

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
                                                    { sqr | highlightType = [ Types.ChosenSquare ], pos = sqr.pos }
                                                else
                                                    {sqr | highlightType = [Types.None]}
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
            ( model, Cmd.batch [ Model.playervsAiCheckmateCheck model.game.gameId, moveFigureAiCmd, Model.playervsAiCheckmateCheck model.game.gameId ] )

        Model.Help ->
            ( model, Model.playerVsAiHelp model.game.gameId )

        Model.PlayerVsAiHelp (Ok move) ->
            let
                _ =
                    Debug.log " " (toString move)
            in
            update (Model.SquareSelected (Tuple.second move.from) (Tuple.first move.from) Model.FirstClick)
                { model | helpHighlightPos = move.to }

        Model.CheckmateCheck (Ok status) ->
            let
                _ =
                    Debug.log "CheckmateCheck " (toString status)
            in
            if String.contains status "check mate" then
                update Model.GameOver model
            else
                ( model, Cmd.none )

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

        Model.TwoPlayerGame ->
            ( { model | route = Model.GameTwo }, Cmd.none )

        Model.QuitGame ->
            ( { model
                | route = Model.MainMenu
                , selectedSquare = ( -1, -1 )
                , playerColor = Types.White
                , errors = []
                , game = { gameType = Types.NoGame, gameId = "" }
                , board = createInitialBoard
                , highscores = []
                , currTime = 0
                , startTime = 0
                , score = 0
              }
            , Cmd.none
            )

        Model.GameOver ->
            let
                currentGame =
                    model.game
            in
            ( { model
                | route =
                    if model.winner then
                        Model.GameOverMenu
                    else
                        Model.GameOverLost
                , startTime = 0
                , game = { currentGame | gameType = Types.NoGame }
              }
            , Cmd.none
            )

        Model.PostScore (Ok val) ->
            ( model, Cmd.none )

        Model.NameChanged name ->
            ( { model | playersName = name }, Cmd.none )

        Model.PostHighscores ->
            ( { model | route = Model.MainMenu }, Model.postHighscores model.playersName (toString model.score) )

        Model.Tick newTime ->
            let
                checkGameOver =
                    if (round (Time.inSeconds newTime) % 3) == 0 && model.game.gameType /= Types.NoGame then
                        Model.playervsAiCheckmateCheck model.game.gameId
                    else
                        Cmd.none

                currGame =
                    model.game
            in
            ( { model
                | currTime = newTime
                , score =
                    if model.startTime > 0 then
                        round (Time.inSeconds newTime - Time.inSeconds model.startTime)
                    else
                        model.score
              }
            , checkGameOver
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

        Model.CheckmateCheck (Err e) ->
            printErrors e model

        Model.PostScore (Err e) ->
            printErrors e model


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
                            if square.pos /= helpHighlightPosReverse && square.pos == ( row, col ) && not (List.member Types.ChosenSquare square.highlightType) && model.playerColor == square.figure.color then
                                { square | highlightType = [ Types.ChosenSquare ] }
                            else if square.pos == helpHighlightPosReverse then
                                { square | highlightType = [ Types.AIRecommmends ] }
                            else
                                { square
                                    | highlightType =
                                        if List.member Types.Check square.highlightType then
                                            [ Types.None, Types.Check ]
                                        else
                                            [ Types.None ]
                                }
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
                                { square | highlightType = [ Types.SuccessfulMove ], figure = movedSquare.figure }
                            else if square.pos == movedSquare.pos then
                                { square | highlightType = [ Types.None ], figure = Types.Figure Types.Empty Types.NoColor "" }
                            else
                                { square
                                    | highlightType = [ Types.None ]
                                }
                        )
            }
