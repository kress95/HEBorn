module OS.SessionManager.WindowManager.Messages exposing (..)

import Draggable
import OS.SessionManager.WindowManager.Models exposing (WindowID)
import Apps.Messages as Apps


type Msg
    = WindowMsg WindowID Apps.AppMsg
    | Close WindowID
    | ToggleMaximize WindowID
    | Minimize WindowID
    | SwitchContext WindowID
    | UpdateFocusTo (Maybe WindowID)
    | Restore WindowID
      -- WINDOW DRAGGIN'
    | OnDragBy Draggable.Delta
    | StartDragging WindowID
    | StopDragging
    | DragMsg (Draggable.Msg WindowID)
