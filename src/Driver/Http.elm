module Driver.Http exposing (Msg, request, send)

import Http


type alias RequestID =
    String


type alias RequestBody =
    String


type Msg
    = HttpResponse RequestID (Result Http.Error RequestBody)


request : String -> String -> String -> Http.Request RequestBody
request url path payload =
    (Http.request
        { method = "POST"
        , headers = []
        , url = url ++ "/" ++ path
        , body = Http.stringBody "application/json" payload
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
    )


send : Http.Request RequestBody -> RequestID -> Cmd Msg
send request id =
    Http.send (HttpResponse id) request
