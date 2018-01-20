module Apps.LogViewer.Menu.Update exposing (update)

import ContextMenu exposing (ContextMenu)
import Game.Data as Game
import Apps.LogViewer.Config exposing (..)
import Apps.LogViewer.Menu.Models exposing (Model)
import Apps.LogViewer.Menu.Messages exposing (Msg(..))
import Core.Dispatch as Dispatch exposing (Dispatch)


update : Config msg -> Msg -> Model -> ( Model, Cmd Msg, Dispatch )
update config msg model =
    case msg of
        MenuMsg msg ->
            let
                ( menu_, cmd ) =
                    ContextMenu.update msg model.menu
            in
                ( { model | menu = menu_ }, Cmd.map MenuMsg cmd, Dispatch.none )

        MenuClick action ->
            ( model, Cmd.none, Dispatch.none )
