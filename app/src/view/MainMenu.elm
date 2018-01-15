module MainMenu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (highscoresStyle)


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Model.ShowGameTypesMenu ] [ text "Start new game" ]
        , br [] []
        , button [ onClick Model.ShowHighscoresMenu ] [ text "Highscores" ]
        ]
