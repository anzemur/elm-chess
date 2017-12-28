module Main exposing (..)

import Model exposing (..)


-- Just the barebones structure for running the app, model, view and update are in separate files


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
