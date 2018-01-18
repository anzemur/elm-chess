module Board exposing (..)

-- Holds the current state of the board and makes basic operations on the board
-- The whole logic of the game is played here, the view will just receive the
-- board through the model and present its state

import Figure exposing (createFigure)
import Types exposing (Board, Color, Figure, FigureType, Square)


-- Creates an initial board layout for chess game


createInitialBoard : Board
createInitialBoard =
    { board =
        List.map
            (\boardRow ->
                List.map (\square -> { square | figure = getInitFigure square.pos }) boardRow
            )
            createBoard.board
    }



-- Returns a figure for each position on a initial board


getInitFigure : ( Int, Int ) -> Figure
getInitFigure pos =
    case pos of
        -- Rooks
        ( 0, 0 ) ->
            createFigure Types.Black Types.Rook

        ( 0, 7 ) ->
            createFigure Types.Black Types.Rook

        ( 7, 0 ) ->
            createFigure Types.White Types.Rook

        ( 7, 7 ) ->
            createFigure Types.White Types.Rook

        -- Pawns
        ( 1, _ ) ->
            createFigure Types.Black Types.Pawn

        ( 6, _ ) ->
            createFigure Types.White Types.Pawn

        -- Knights
        ( 0, 1 ) ->
            createFigure Types.Black Types.Knight

        ( 0, 6 ) ->
            createFigure Types.Black Types.Knight

        ( 7, 1 ) ->
            createFigure Types.White Types.Knight

        ( 7, 6 ) ->
            createFigure Types.White Types.Knight

        -- Bishops
        ( 0, 2 ) ->
            createFigure Types.Black Types.Bishop

        ( 0, 5 ) ->
            createFigure Types.Black Types.Bishop

        ( 7, 2 ) ->
            createFigure Types.White Types.Bishop

        ( 7, 5 ) ->
            createFigure Types.White Types.Bishop

        -- Kings
        ( 0, 4 ) ->
            createFigure Types.Black Types.King

        ( 7, 3 ) ->
            createFigure Types.White Types.King

        -- Queens
        ( 0, 3 ) ->
            createFigure Types.Black Types.Queen

        ( 7, 4 ) ->
            createFigure Types.White Types.Queen

        ( a, b ) ->
            --FIXME repair the figure "must have" values
            { figureType = Types.Empty, color = Types.NoColor, img_src = "" }



-- Creates a basic board without figures


createBoard : Board
createBoard =
    { board =
        List.map
            (\row ->
                List.map
                    (\col ->
                        --FIXME repair the figure "must have" values
                        { pos = ( row, col ), highlightType = [Types.None],figure = { figureType = Types.Bishop, color = Types.Black, img_src = "assets/rook_black.svg"} }
                     -- Square type
                    )
                    (List.range 0 7)
            )
            (List.range 0 7)
    }
