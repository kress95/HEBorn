module Apps.LogViewer.Subscriptions exposing (..)

import Apps.LogViewer.Config exposing (..)
import Apps.LogViewer.Models exposing (Model)
import Apps.LogViewer.Messages exposing (Msg(..))
import Apps.LogViewer.Menu.Subscriptions as Menu


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.map (MenuMsg >> config.toMsg) (Menu.subscriptions model.menu)
