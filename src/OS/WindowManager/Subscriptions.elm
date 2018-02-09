module OS.WindowManager.Subscriptions exposing (subscriptions)

import Dict exposing (Dict)
import Utils.Maybe as Maybe
import Apps.Browser.Subscriptions as Browser
import Apps.DBAdmin.Subscriptions as Database
import Apps.Explorer.Subscriptions as Explorer
import Apps.LocationPicker.Subscriptions as LocationPicker
import Apps.LogViewer.Subscriptions as LogViewer
import Apps.TaskManager.Subscriptions as TaskManager
import Game.Servers.Models as Servers exposing (Server)
import Game.Servers.Shared as Servers exposing (CId(..))
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Helpers exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)
import OS.WindowManager.Shared exposing (..)


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    model.apps
        |> Dict.toList
        |> List.filterMap (uncurry <| subsApp config model)
        |> Sub.batch


subsApp : Config msg -> Model -> AppId -> App -> Maybe (Sub msg)
subsApp config model appId app =
    let
        activeGateway =
            model
                |> getWindow (getWindowId app)
                |> Maybe.andThen (getWindowGateway config model)

        activeServer =
            getAppActiveServer config app
    in
        case Maybe.uncurry activeServer activeGateway of
            Just ( active, gateway ) ->
                subsAppDelegate config active gateway appId app

            Nothing ->
                -- this shouldn't happen really
                Nothing


subsAppDelegate :
    Config msg
    -> ( CId, Server )
    -> ( CId, Server )
    -> AppId
    -> App
    -> Maybe (Sub msg)
subsAppDelegate config ( cid, server ) ( gCid, gServer ) appId app =
    case getModel app of
        BrowserModel appModel ->
            appModel
                |> Browser.subscriptions
                    (browserConfig appId cid server config)
                |> Just

        DBAdminModel appModel ->
            appModel
                |> Database.subscriptions (dbAdminConfig appId config)
                |> Just

        ExplorerModel appModel ->
            appModel
                |> Explorer.subscriptions
                    (explorerConfig appId cid server config)
                |> Just

        LocationPickerModel appModel ->
            appModel
                |> LocationPicker.subscriptions
                    (locationPickerConfig appId config)
                |> Just

        LogViewerModel appModel ->
            appModel
                |> LogViewer.subscriptions
                    (logViewerConfig appId cid server config)
                |> Just

        TaskManagerModel appModel ->
            appModel
                |> TaskManager.subscriptions
                    (taskManagerConfig appId cid server config)
                |> Just

        _ ->
            Nothing
