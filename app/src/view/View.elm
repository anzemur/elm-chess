module View exposing (..)

import GameBoard
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Msg)


-- Main view of the app, we add subcomponents to separate files and expose their view functions inside this one


view : Model -> Html Msg
view model =
    div [] [ GameBoard.view model ]
