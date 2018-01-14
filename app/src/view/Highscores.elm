module Highscores exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import List
import Model exposing (Model, Msg)
import Styles exposing (highscoresStyle)


view : Model -> Html Msg
view model =
    div [ highscoresStyle ] [ text "HIGHSCORE", br [] [], showHighscores model ]


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
