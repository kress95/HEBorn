module OS.SessionManager.Dock.Update exposing (update)

import OS.SessionManager.Models exposing (..)
import OS.SessionManager.Dock.Messages exposing (..)
import OS.SessionManager.WindowManager.Update as WM
import OS.SessionManager.WindowManager.Messages as WM
import OS.SessionManager.WindowManager.Models as WM


-- dock update is quite different, the dock is tightly integrated with
-- both the SessionManager and WindowManager, so it needs to access both


update :
    Msg
    -> Model
    -> Model
update msg model =
    Maybe.withDefault model (maybeUpdate msg model)



-- internals


maybeUpdate msg model =
    case msg of
        OpenApp app ->
            Maybe.map (openApp app model) (current model)

        CloseApps app ->
            Maybe.map (closeApps app model) (current model)

        RestoreApps app ->
            Maybe.map (restoreApps app model) (current model)

        MinimizeApps app ->
            Maybe.map (minimizeApps app model) (current model)

        CloseWindow ref ->
            Maybe.map (closeWindow ref model) (current model)

        RestoreWindow ref ->
            Maybe.map (restoreWindow ref model) (current model)

        MinimizeWindow ref ->
            Maybe.map (minimizeWindow ref model) (current model)

        FocusWindow ref ->
            Maybe.map (focusWindow ref model) (current model)


openApp app model wm =
    refresh (WM.openWindow app wm) model


closeApps app model wm =
    refresh (WM.closeAppWindows app wm) model


restoreApps app model wm =
    refresh (WM.restoreAppWindows app wm) model


minimizeApps app model wm =
    refresh (WM.minimizeAppWindows app wm) model


closeWindow ( _, id ) model wm =
    refresh (WM.closeWindow id wm) model


restoreWindow ( _, id ) model wm =
    refresh (WM.restoreWindow id wm) model


minimizeWindow ( _, id ) model wm =
    refresh (WM.minimizeWindow id wm) model


focusWindow ( _, id ) model wm =
    refresh (WM.focusWindow id wm) model
