module OS.SessionManager.Messages exposing (..)

-- FIXME: stop using CoreMsg on Game, use GameMsg instead
-- import OS.SessionManager.Models exposing (..)

import OS.SessionManager.WindowManager.Messages as WindowManager
import OS.SessionManager.Dock.Messages as Dock


{-| TODO: remove this once CoreMsg gets replaced with GameMsg
-}
type alias ServerID =
    String



type Msg
    = WindowManagerMsg ServerID WindowManager.Msg
    | DockMsg Dock.Msg
