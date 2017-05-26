module OS.Messages exposing (OSMsg(..))

import Events.Models
import Requests.Models
import OS.SessionManager.WindowManager.Messages
import OS.Dock.Messages
import OS.Menu.Messages as Menu


type OSMsg
    = MsgWM OS.SessionManager.WindowManager.Messages.Msg
    | MsgDock OS.Dock.Messages.Msg
    | ContextMenuMsg Menu.Msg
    | Event Events.Models.Event
    | Request Requests.Models.Request
    | Response Requests.Models.Request Requests.Models.Response
    | NoOp
