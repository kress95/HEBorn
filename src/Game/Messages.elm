module Game.Messages exposing (GameMsg(..))

-- import Events.Models
-- import Requests.Models
import Game.Account.Messages
import Game.Servers.Messages
import Game.Network.Messages
import Game.Meta.Messages
import Request.Types exposing (RequestType(..))


type GameMsg
    = MsgAccount Game.Account.Messages.AccountMsg
    | MsgServers Game.Servers.Messages.ServerMsg
    | MsgNetwork Game.Network.Messages.NetworkMsg
    | MsgMeta Game.Meta.Messages.MetaMsg
    -- | Event Events.Models.Event
    | Request RequestType String
    | Response RequestType String
    | NoOp
