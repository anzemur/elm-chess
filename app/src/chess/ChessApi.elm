module ChessApi exposing (..)

import Http
import Json.Decode as JD exposing (Decoder, field, int, list, map2, string)
import Types exposing (PlayerScore)


baseUrl =
    --"http://localhost:3000/api/v1/"
    "https://chess-api-chess.herokuapp.com/api/v1/"


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



--
-- corsGet : Http.request
-- corsGet =
--     { verb = "GET"
--     , headers =
--         [ ("Origin", "http://elm-lang.org")
--         , ("Access-Control-Request-Method", "POST")
--         , ("Access-Control-Request-Headers", "X-Custom-Header")
--         ]
--     , url = "http://example.com/hats"
--     , body = empty
--     }
