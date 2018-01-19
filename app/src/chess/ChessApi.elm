module ChessApi exposing (..)

import Char
import Http
import Json.Decode as JD exposing (Decoder, field, int, list, map2, string)
import Json.Encode as Encode
import Types exposing (Move, PlayerScore)


baseUrl =
    "http://localhost:3000/api/v1/"



-- "https://chess-api-chess.herokuapp.com/api/v1/"
-- Returns the list of top 5 players in chess


getHighscore =
    Http.get (baseUrl ++ "highscores") decodeHighscoreUrl


decodeHighscoreUrl : Decoder (List PlayerScore)
decodeHighscoreUrl =
    list playerScoreDecoder


playerScoreDecoder : Decoder PlayerScore
playerScoreDecoder =
    map2 PlayerScore
        (field "name" string)
        (field "score_out" string)



-- Starts a new game and returns a game ID - PlayerVsAi


startGameOne =
    Http.get (baseUrl ++ "chess/one") decodeStartGameOneUrl


decodeStartGameOneUrl : Decoder String
decodeStartGameOneUrl =
    field "game_id" string



-- Sends a move for a player to API in PlayerVsAiGame


moveFigurePlayerOne : String -> ( Int, Int ) -> ( Int, Int ) -> Http.Request String
moveFigurePlayerOne game_id from to =
    let
        _ =
            Debug.log "moveFigureplayerone: fromto:" (toString from ++ " " ++ toString to)

        body =
            Http.jsonBody
                (Encode.object
                    [ ( "game_id", Encode.string game_id )
                    , ( "from", Encode.string (parseElmToApiPos from) )
                    , ( "to", Encode.string (parseElmToApiPos to) )
                    ]
                )
    in
    Http.post
        (baseUrl ++ "chess/one/move/player")
        body
        (field "status" string)



-- Send the_game id to the backend to receive back the move that AI makes


moveFigureAi game_id =
    let
        bodyZ =
            Http.jsonBody
                (Encode.object
                    [ ( "game_id", Encode.string game_id ) ]
                )
    in
    Http.request
        { method = "POST"
        , headers = []
        , url = baseUrl ++ "chess/one/move/ai"
        , body = bodyZ
        , expect = Http.expectJson moveFigureAiDecoder
        , timeout = Nothing
        , withCredentials = False
        }


moveFigureAiDecoder : Decoder Move
moveFigureAiDecoder =
    map2
        (\fromz toz ->
            let
                _ =
                    Debug.log "highscores get err" (fromz ++ " " ++ toz)
            in
            { from = parseApiPosition fromz
            , to = parseApiPosition toz
            }
        )
        (field "from" string)
        (field "to" string)


parseElmToApiPos : ( Int, Int ) -> String
parseElmToApiPos pos =
    String.fromChar (Char.fromCode (Tuple.second pos + 97)) ++ toString (abs (Tuple.first pos - 8))


parseApiPosition : String -> ( Int, Int )
parseApiPosition str =
    let
        charList =
            String.toList str
    in
    List.foldl
        (\char tmp ->
            if Char.isDigit char then
                ( Tuple.first tmp, abs (Char.toCode char - 49 - 7) )
            else
                ( Char.toCode char - 97, Tuple.second tmp )
        )
        ( 0, 0 )
        charList


playerVsAiHelp game_id =
    let
        body =
            Http.jsonBody
                (Encode.object
                    [ ( "game_id", Encode.string game_id ) ]
                )
    in
    Http.post
        (baseUrl ++ "chess/one/help")
        body
        playerVsAiHelpEncoder


playerVsAiHelpEncoder : Decoder Move
playerVsAiHelpEncoder =
    map2
        (\fromz toz ->
            let
                _ =
                    Debug.log "PlayerVsAiEncoderHelp: " (fromz ++ " " ++ toz)
            in
            { from = parseApiPosition fromz
            , to = parseApiPosition toz
            }
        )
        (field "from" string)
        (field "to" string)
