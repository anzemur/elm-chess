module Highscores exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (highscoresStyle)


view : Model -> Html Msg
view model =
    div [ highscoresStyle ]
        [ br [] []
        , img [ src "/src/assets/other/Highscores.png" ] []
        , br [] []
        , showHighscores model
        , br [] []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/MainMenu.png\")" )
                , ( "width", "512px" )
                , ( "height", "110px" )
                ]
            , onClick Model.ShowMainMenu
            ]
            []
        ]


showHighscores : Model -> Html Msg
showHighscores model =
    div []
        (List.foldl
            (\player tmp ->
                text (player.name ++ " " ++ player.score_out) :: (br [] [] :: tmp)
            )
            []
            model.highscores
        )
