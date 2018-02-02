module Apps.Explorer.Subscriptions exposing (..)

import Apps.Explorer.Config exposing (..)
import Apps.Explorer.Models exposing (Model)
import Apps.Explorer.Messages exposing (Msg(..))
import Apps.Explorer.Menu.Subscriptions as Menu


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.map (MenuMsg >> config.toMsg) (Menu.subscriptions model.menu)
