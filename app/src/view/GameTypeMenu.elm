module GameTypeMenu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List
import Model exposing (Model, Msg)
import Styles exposing (mainMenuStyle)


view : Model -> Html Msg
view model =
    div [ mainMenuStyle ]
        [ img [ src "/src/assets/other/GameMode.png" ] []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/PlayerVsComputer.png\")" )
                , ( "width", "482px" )
                , ( "height", "110px" )
                ]
            , onClick Model.OnePlayerGame
            ]
            []
        , br [] []
        , button
            [ style
                [ ( "background", "url(\"/src/assets/buttons/PlayerVsPlayer.png\")" )
                , ( "width", "482px" )
                , ( "height", "110px" )
                ]
            , onClick Model.TwoPlayerGame
            ]
            []
        , br [] []
        , br [] []
        , br [] []
        , br [] []
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
