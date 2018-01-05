module Figure exposing (..)

-- hold the state of a figure (which figure, position, alive/dead, white/black..)

import Types exposing (Color, Figure, FigureType)


-- Creates a figure for a given color and type


createFigure : Color -> FigureType -> Figure
createFigure figColor figType =
    case ( figColor, figType ) of
        ( Types.Black, Types.King ) ->
            { figureType = figType, color = figColor, img_src = "assets/king_black.svg", pos = ( 0, 0 ) }

        ( Types.Black, Types.Queen ) ->
            { figureType = figType, color = figColor, img_src = "assets/queen_black.svg", pos = ( 0, 0 ) }

        ( Types.Black, Types.Bishop ) ->
            { figureType = figType, color = figColor, img_src = "assets/bishop_black.svg", pos = ( 0, 0 ) }

        ( Types.Black, Types.Pawn ) ->
            { figureType = figType, color = figColor, img_src = "assets/pawn_black.svg", pos = ( 0, 0 ) }

        ( Types.Black, Types.Rook ) ->
            { figureType = figType, color = figColor, img_src = "assets/rook_black.svg", pos = ( 0, 0 ) }

        ( Types.Black, Types.Knight ) ->
            { figureType = figType, color = figColor, img_src = "assets/knight_black.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.King ) ->
            { figureType = figType, color = figColor, img_src = "assets/king_white.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.Queen ) ->
            { figureType = figType, color = figColor, img_src = "assets/queen_white.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.Bishop ) ->
            { figureType = figType, color = figColor, img_src = "assets/bishop_white.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.Pawn ) ->
            { figureType = figType, color = figColor, img_src = "assets/pawn_white.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.Rook ) ->
            { figureType = figType, color = figColor, img_src = "assets/rook_white.svg", pos = ( 0, 0 ) }

        ( Types.White, Types.Knight ) ->
            { figureType = figType, color = figColor, img_src = "assets/knight_white.svg", pos = ( 0, 0 ) }
