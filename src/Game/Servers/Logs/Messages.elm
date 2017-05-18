module Game.Servers.Logs.Messages exposing (LogMsg(..))

import Json.Decode exposing (Value)


type LogMsg
    = LogIndex Value
