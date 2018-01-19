module GameOverMenu exposing (..)

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
        , img [ src "/src/assets/other/YouWon.png" ] []
        , br [] []
        , br [] []
        , input
            [ onInput Model.NameChanged
            , style
                [ ( "height", "40px" )
                , ( "width", "400px" )
                , ( "align", "middle" )
                ]
            ]
            []
        , br [] []
        , br [] []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/Submit.png\")" )
                , ( "width", "512px" )
                , ( "height", "100px" )
                ]
            , onClick Model.PostHighscores
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
