module Request.Messages exposing (Msg(..))

import Request.Types exposing (RequestType)
import Json.Decode as Decode exposing (Value)
import Game.Messages exposing (GameMsg(Request))


type alias Payload =
    String


request : RequestType -> Payload -> GameMsg
request t payload =
    Request t payload
