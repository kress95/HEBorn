module Driver.Websocket.Messages exposing (Msg(..))

import Json.Decode
import Requests.Models exposing (RequestID)


type Msg
    = UpdateSocketParams ( String, String )
    | JoinChannel String
    | Joined Json.Decode.Value
    | NewNotification Json.Decode.Value
    | NewReply Json.Decode.Value RequestID
