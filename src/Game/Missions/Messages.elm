module Game.Missions.Messages exposing (Msg(..))

import Apps.Messages as Apps
import OS.Header.Messages as Header
import OS.SessionManager.Dock.Messages as Dock


type alias WindowID =
    String


type alias ServerID =
    String


type Msg
    = AppsMsg ServerID WindowID Apps.Msg
    | HeaderMsg ServerID Header.Msg
    | DockMsg ServerID Dock.Msg
