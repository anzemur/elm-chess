module ChessApi exposing (..)

import Http
import Json.Decode as JD exposing (Decoder, field, int, list, map2, string)
import Json.Encode as Encode
import Types exposing (PlayerScore)


baseUrl =
    --"http://localhost:3000/api/v1/"
    "https://chess-api-chess.herokuapp.com/api/v1/"



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
        (field "score" int)



-- Starts a new game and returns a game ID


startGameOne =
    Http.get (baseUrl ++ "chess/one") decodeStartGameOneUrl


decodeStartGameOneUrl : Decoder String
decodeStartGameOneUrl =
    field "game_id" string



-- Sends a move for a player to aPI


moveFiguresPlayerOne game_id from to =
    let
        body =
            Http.jsonBody
                (Encode.object
                    [ ( "game_id", Encode.string game_id )
                    , ( "from", Encode.string from )
                    , ( "to", Encode.string to )
                    ]
                )
    in
    Http.post
        (baseUrl ++ "chess/one/move/player")
        body
        (field "status" string)
