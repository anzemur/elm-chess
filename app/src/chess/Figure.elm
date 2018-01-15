module Figure exposing (..)

-- hold the state of a figure (which figure, position, alive/dead, white/black..)

import Types exposing (Color, Figure, FigureType)


-- Creates a figure for a given color and type


createFigure : Color -> FigureType -> Figure
createFigure figColor figType =
    case ( figColor, figType ) of
        ( Types.Black, Types.King ) ->
            { figureType = figType, color = figColor, img_src = "assets/king_black.svg" }

        ( Types.Black, Types.Queen ) ->
            { figureType = figType, color = figColor, img_src = "assets/queen_black.svg" }

        ( Types.Black, Types.Bishop ) ->
            { figureType = figType, color = figColor, img_src = "assets/bishop_black.svg" }

        ( Types.Black, Types.Pawn ) ->
            { figureType = figType, color = figColor, img_src = "assets/pawn_black.svg" }

        ( Types.Black, Types.Rook ) ->
            { figureType = figType, color = figColor, img_src = "assets/rook_black.svg" }

        ( Types.Black, Types.Knight ) ->
            { figureType = figType, color = figColor, img_src = "assets/knight_black.svg" }

        ( Types.White, Types.King ) ->
            { figureType = figType, color = figColor, img_src = "assets/king_white.svg" }

        ( Types.White, Types.Queen ) ->
            { figureType = figType, color = figColor, img_src = "assets/queen_white.svg" }

        ( Types.White, Types.Bishop ) ->
            { figureType = figType, color = figColor, img_src = "assets/bishop_white.svg" }

        ( Types.White, Types.Pawn ) ->
            { figureType = figType, color = figColor, img_src = "assets/pawn_white.svg" }

        ( Types.White, Types.Rook ) ->
            { figureType = figType, color = figColor, img_src = "assets/rook_white.svg" }

        ( Types.White, Types.Knight ) ->
            { figureType = figType, color = figColor, img_src = "assets/knight_white.svg" }

        ( _, _ ) ->
            { figureType = Types.Empty, color = Types.NoColor, img_src = "" }
