module GameOverLost exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick, onInput)
import List
import Model exposing (Model, Msg)
import Styles exposing (mainMenuStyle)


view : Model -> Html Msg
view model =
    div [ mainMenuStyle ]
        [ br [] []
        , img [ src "/src/assets/other/YouLost.png" ] []
        , br [] []
        , br [] []
        , br [] []
        , br [] []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/MainMenu.png\")" )
                , ( "width", "512px" )
                , ( "height", "100px" )
                ]
            , onClick Model.ShowMainMenu
            ]
            []
        , br [] []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/Highscores.png\")" )
                , ( "width", "512px" )
                , ( "height", "100px" )
                ]
            , onClick Model.ShowHighscoresMenu
            ]
            []
        ]
