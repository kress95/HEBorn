module OS.SessionManager.Messages exposing (..)

import OS.SessionManager.WindowManager.Messages as WindowManager


type Msg
    = WindowManagerMsg WindowManager.Msg
