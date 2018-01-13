module View exposing (..)

import GameBoard
import Highscores
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Msg)
import Styles


-- Main view of the app, we add subcomponents to separate files and expose their view functions inside this one


view : Model -> Html Msg
view model =
    div [ Styles.mainViewStyle ] [ GameBoard.view model, Highscores.view model ]
