module GameTypeMenu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (highscoresStyle)


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Model.OnePlayerGame ] [ text "One Player Game" ]
        , br [] []
        , button [ onClick Model.TwoPlayerGame ] [ text "Two Players Game" ]
        , br [] []
        , button [ onClick Model.ShowMainMenu ] [ text "Main Menu" ]
        ]
