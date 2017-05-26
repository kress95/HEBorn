module OS.Dock.Messages exposing (Msg(..))

import OS.SessionManager.WindowManager.Messages
import OS.SessionManager.WindowManager.Models exposing (Windows)


type Msg
    = WindowsChanges Windows
