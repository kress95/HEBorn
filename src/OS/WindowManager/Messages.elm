module OS.WindowManager.Messages exposing (..)

import Draggable
import Game.Meta.Types.Context exposing (..)
import Game.Meta.Types.Apps.Desktop as DesktopApp exposing (DesktopApp)
import Apps.Params as AppParams exposing (AppParams)
import Apps.LogViewer.Messages as LogViewer
import Apps.TaskManager.Messages as TaskManager
import Apps.Browser.Messages as Browser
import Apps.Explorer.Messages as Explorer
import Apps.DBAdmin.Messages as DBAdmin
import Apps.ConnManager.Messages as ConnManager
import Apps.BounceManager.Messages as BounceManager
import Apps.Finance.Messages as Finance
import Apps.Hebamp.Messages as Hebamp
import Apps.ServersGears.Messages as ServersGears
import Apps.LocationPicker.Messages as LocationPicker
import Apps.Email.Messages as Email
import Apps.Bug.Messages as Bug
import Apps.Calculator.Messages as Calculator
import Apps.BackFlix.Messages as BackFlix
import Apps.FloatingHeads.Messages as FloatingHeads
import OS.WindowManager.Shared exposing (..)


type Msg
    = NewApp DesktopApp (Maybe Context) (Maybe AppParams)
    | OpenApp Context AppParams
    | PinWindow WindowId
    | UnpinWindow WindowId
    | CloseWindow WindowId
      -- window handling
    | Minimize WindowId
    | ToggleVisibility WindowId
    | ToggleMaximize WindowId
    | SelectContext Context WindowId
    | UpdateFocus (Maybe WindowId)
      -- drag messages
    | StartDrag WindowId
    | Dragging Draggable.Delta
    | StopDrag
    | DragMsg (Draggable.Msg WindowId)
      -- dock messages
    | ClickIcon DesktopApp
    | MinimizeAll DesktopApp
    | CloseAll DesktopApp
      -- app messages
    | BackFlixMsg AppId BackFlix.Msg
    | BounceManagerMsg AppId BounceManager.Msg
    | BrowserMsg AppId Browser.Msg
    | BugMsg AppId Bug.Msg
    | CalculatorMsg AppId Calculator.Msg
    | ConnManagerMsg AppId ConnManager.Msg
    | DBAdminMsg AppId DBAdmin.Msg
    | EmailMsg AppId Email.Msg
    | ExplorerMsg AppId Explorer.Msg
    | FinanceMsg AppId Finance.Msg
    | FloatingHeadsMsg AppId FloatingHeads.Msg
    | HebampMsg AppId Hebamp.Msg
    | LocationPickerMsg AppId LocationPicker.Msg
    | LogViewerMsg AppId LogViewer.Msg
    | ServersGearsMsg AppId ServersGears.Msg
    | TaskManagerMsg AppId TaskManager.Msg
