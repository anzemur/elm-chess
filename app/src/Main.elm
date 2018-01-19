module Main exposing (..)

import Html
import Model exposing (Model, Msg, init, subscriptions)
import Update
import View


-- Just the barebones structure for running the app, model, view and update are in separate files
-- with API cca 3500 lines of code


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = Model.subscriptions
        }
