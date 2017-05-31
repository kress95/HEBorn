module OS.SessionManager.Subscriptions exposing (..)

import OS.SessionManager.Models exposing (..)
import OS.SessionManager.Messages exposing (..)
import OS.SessionManager.WindowManager.Models as WindowManager
import OS.SessionManager.WindowManager.Subscriptions as WindowManager
import Game.Models exposing (GameModel)


-- TODO: this needs to change to add pinned window support


subscriptions : GameModel -> Model -> Sub Msg
subscriptions game model =
    let
        wmID =
            unsafeGetActive model

        windowManagerSub =
            model
                |> current
                |> Maybe.map (windowManager wmID game)
                |> defaultNone
    in
        Sub.batch [ windowManagerSub ]



-- internals


windowManager : ServerID -> GameModel -> WindowManager.Model -> Sub Msg
windowManager id game model =
    model
        |> WindowManager.subscriptions game
        |> Sub.map (WindowManagerMsg id)


defaultNone : Maybe (Sub Msg) -> Sub Msg
defaultNone =
    Maybe.withDefault Sub.none
