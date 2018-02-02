module Apps.Browser.Subscriptions exposing (..)

import Apps.Browser.Config exposing (..)
import Apps.Browser.Models exposing (Model)
import Apps.Browser.Messages exposing (Msg(..))
import Apps.Browser.Menu.Subscriptions as Menu


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.map (MenuMsg >> config.toMsg) (Menu.subscriptions model.menu)
