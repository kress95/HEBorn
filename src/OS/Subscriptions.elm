module OS.Subscriptions exposing (subscriptions)

import OS.WindowManager.Models as WindowManager
import OS.WindowManager.Subscriptions as WindowManager
import OS.Config exposing (..)
import OS.Models exposing (..)


--import OS.SessionManager.Models as SessionManager
--import OS.SessionManager.Subscriptions as SessionManager


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    windowManager config model.windowManager



-- internals


windowManager : Config msg -> WindowManager.Model -> Sub msg
windowManager config model =
    Sub.none



--let
--    config_ =
--        smConfig config
--in
--    model
--        |> SessionManager.subscriptions config_
