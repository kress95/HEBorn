module OS.SessionManager.Dock.Update exposing (update)

import OS.SessionManager.Models exposing (..)
import OS.SessionManager.Dock.Messages exposing (..)
import OS.SessionManager.WindowManager.Update as WindowManager
import OS.SessionManager.WindowManager.Messages as WindowManager
import OS.SessionManager.WindowManager.Models as WindowManager


-- dock update is quite different, the dock is tightly integrated with
-- both the SessionManager and WindowManager, so it needs to access both


update :
    Msg
    -> Model
    -> Model
update msg model =
    case msg of
        OpenApp app ->
            model

        MinimizeApps app ->
            model

        RestoreApps app ->
            model

        CloseApps app ->
            model

        MinimizeWindow id ->
            model

        RestoreWindow id ->
            model

        CloseWindow id ->
            model
