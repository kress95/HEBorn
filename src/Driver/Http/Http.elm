module Driver.Http.Http exposing (..)

import Http
import Driver.Http.Models exposing (decodeMsg)
import Core.Messages exposing (CoreMsg)

type alias RequestID = String



send : String -> String -> RequestID -> String -> Cmd CoreMsg
send apiHttpUrl path id payload =
    Http.send
        (decodeMsg id)
        (Http.request
            { method = "POST"
            , headers = []
            , url = apiHttpUrl ++ "/" ++ path
            , body = Http.stringBody "application/json" payload
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }
        )
