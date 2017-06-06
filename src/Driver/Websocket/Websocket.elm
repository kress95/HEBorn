module Driver.Websocket.Websocket exposing (send)

import Json.Encode
import Phoenix
import Phoenix.Push as Push
import Driver.Websocket.Messages exposing (Msg(NewReply))
import Core.Messages exposing (CoreMsg(MsgWebsocket))

type alias RequestID = String


send : String -> String -> RequestID -> Json.Encode.Value -> Cmd CoreMsg
send channel topic request_id payload =
    let
        message =
            Push.init channel topic
                |> Push.withPayload payload
                |> Push.onOk (\m -> NewReply m request_id)
                |> Push.onError (\m -> NewReply m request_id)
    in
        Cmd.map
            MsgWebsocket
            (Phoenix.push "wss://api.hackerexperience.com/websocket" message)
