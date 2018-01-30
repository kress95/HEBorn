module OS.WindowManager.Helpers exposing (..)

import Game.Meta.Types.Context exposing (..)
import Game.Servers.Shared exposing (CId(..))
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Models exposing (..)
import OS.WindowManager.Shared exposing (..)


cidToSessionId : CId -> SessionId
cidToSessionId cid =
    case cid of
        GatewayCId id ->
            "gateway_id::" ++ id

        EndpointCId ( nid, ip ) ->
            "endpoint_addr::" ++ nid ++ "::" ++ ip


getSessionId : Config msg -> SessionId
getSessionId =
    .activeServer >> Tuple.first >> cidToSessionId
