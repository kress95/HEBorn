module Apps.TaskManager.Subscriptions exposing (..)

import Time exposing (Time, every, second)
import Apps.TaskManager.Config exposing (..)
import Apps.TaskManager.Models exposing (Model)
import Apps.TaskManager.Messages exposing (Msg(..))
import Apps.TaskManager.Menu.Subscriptions as Menu


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.batch
        [ Sub.map (MenuMsg >> config.toMsg) (Menu.subscriptions model.menu)
        , Time.every second (Tick >> config.toMsg)
        ]
