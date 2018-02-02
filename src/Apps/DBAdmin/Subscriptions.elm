module Apps.DBAdmin.Subscriptions exposing (..)

import Apps.DBAdmin.Config exposing (..)
import Apps.DBAdmin.Models exposing (Model)
import Apps.DBAdmin.Messages exposing (Msg(..))
import Apps.DBAdmin.Menu.Subscriptions as Menu


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.map (MenuMsg >> config.toMsg) (Menu.subscriptions model.menu)
