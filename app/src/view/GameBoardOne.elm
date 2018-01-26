module GameBoardOne exposing (..)

import GameBoard exposing (renderBoard)
import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (figureImgStyle, gameBoardStyle, squareStyle)
import Time
import Types exposing (Board, Figure, Square)


view : Model -> Html Msg
view model =
    div [ Styles.gameBoardStyle ]
        [ div []
            [ text
                (toString (model.score // 60)
                    ++ " : "
                    ++ toString (model.score % 60)
                )
            ]
        , div [ Styles.chessboardStyle ] (renderBoard model)
        , button
            [ style
                [ ( "background", "url(\"assets/buttons/QuitGame.png\")" )
                , ( "width", "200px" )
                , ( "height", "50px" )
                , ( "margin-right", "60px" )
                ]
            , onClick Model.QuitGame
            ]
            []
        , button
            [ style
                [ ( "background", "url(\"assets/buttons/Help.png\")" )
                , ( "width", "200px" )
                , ( "height", "50px" )
                , ( "margin-left", "60px" )
                ]
            , onClick Model.Help
            ]
            []
        ]
