module Game.Dispatcher exposing (Msg)

import Game.Account.API as Account
import Game.Meta.API as Meta
import Game.Network.API as Network
import Game.Servers.API as Servers
import Game.Servers.Filesystem.API as Filesystem
import Game.Servers.Logs.API as Logs
import Game.Servers.Processes.API as Processes


{-| For easier routing, we need to own every request type :|
-}
type Msg
    = AccountRequest Account.Msg
    | MetaRequest Meta.Msg
    | NetworkRequest Network.Msg
    | ServersRequest Servers.Msg
    | ServersFilesystemRequest Filesystem.Msg
    | ServersLogsRequest Logs.Msg
    | ServersProcessesRequest Processes.Msg


type Request
    = Request Msg


type Response a
    = Response Msg a


request : Msg -> Request
request msg =
    Request msg


reply : Msg -> value -> Response Request value
reply msg value =
    Response msg a
