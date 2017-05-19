module Game.Servers.Processes.Messages exposing (ProcessMsg(..))

import Json.Decode exposing (Value)


type ProcessMsg
    = ProcessIndex Value
