module OS.WindowManager.Update exposing (update)

import Draggable
import Draggable.Events as Draggable
import Utils.Maybe as Maybe
import Utils.React as React exposing (React)
import Apps.BackFlix.Update as BackFlix
import Apps.BounceManager.Update as BounceManager
import Apps.Browser.Update as Browser
import Apps.Bug.Update as Bug
import Apps.Calculator.Update as Calculator
import Apps.ConnManager.Update as ConnManager
import Apps.DBAdmin.Update as DBAdmin
import Apps.Email.Update as Email
import Apps.Explorer.Update as Explorer
import Apps.Finance.Update as Finance
import Apps.FloatingHeads.Update as FloatingHeads
import Apps.Hebamp.Update as Hebamp
import Apps.LocationPicker.Update as LocationPicker
import Apps.LogViewer.Update as LogViewer
import Apps.ServersGears.Update as ServersGears
import Apps.TaskManager.Update as TaskManager
import Game.Servers.Models as Servers exposing (Server)
import Game.Servers.Shared as Servers exposing (CId(..))
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Helpers exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)
import OS.WindowManager.Shared exposing (..)


type alias UpdateResponse msg =
    ( Model, React msg )


update : Config msg -> Msg -> Model -> UpdateResponse msg
update config msg model =
    case msg of
        NewApp app maybeContext maybeParams ->
            React.update model

        OpenApp context params ->
            React.update model

        -- window handling
        Close wId ->
            React.update <| close wId model

        Minimize wId ->
            withSession config model <| minimize wId >> React.update

        ToggleVisibility wId ->
            withSession config model <| toggleVisibility wId >> React.update

        ToggleMaximize wId ->
            withWindow wId model <| toggleMaximize >> React.update

        ToggleContext wId ->
            withWindow wId model <| toggleContext >> React.update

        SelectContext context wId ->
            withWindow wId model <| setContext context >> React.update

        UpdateFocus maybeWId ->
            withSession config model <| updateFocus maybeWId >> React.update

        Pin wId ->
            withSession config model <| pin wId >> React.update

        Unpin wId ->
            withSession config model <| unpin wId >> React.update

        -- drag messages
        StartDrag wId ->
            React.update <| startDragging wId (getSessionId config) model

        Dragging ( x, y ) ->
            onDragging x y model

        StopDrag ->
            React.update <| stopDragging model

        DragMsg msg ->
            onDragMsg config msg model

        -- dock messages
        ClickIcon app ->
            -- <| openOrRestore app (getSessionId config) model
            React.update model

        MinimizeAll app ->
            React.update <| minimizeAll app (getSessionId config) model

        CloseAll app ->
            React.update <| closeAll app (getSessionId config) model

        -- app messages
        AppMsg appId appMsg ->
            updateApp config appId appMsg model

        AppsMsg appMsg ->
            updateApps config appMsg model


withSession :
    Config msg
    -> Model
    -> (Session -> ( Session, React msg ))
    -> UpdateResponse msg
withSession config model map =
    let
        sessionId =
            getSessionId config
    in
        model
            |> getSession sessionId
            |> map
            |> Tuple.mapFirst (flip (insertSession sessionId) model)


withWindow :
    WindowId
    -> Model
    -> (Window -> ( Window, React msg ))
    -> UpdateResponse msg
withWindow windowId model map =
    let
        andMap ( window, react ) =
            ( insertWindow windowId window model, react )
    in
        model
            |> getWindow windowId
            |> Maybe.map (map >> andMap)
            |> Maybe.withDefault ( model, React.none )


onDragMsg : Config msg -> Draggable.Msg WindowId -> Model -> UpdateResponse msg
onDragMsg config msg model =
    let
        dragConfig =
            Draggable.customConfig
                [ Draggable.onDragBy (Dragging >> config.toMsg)
                , Draggable.onDragStart (StartDrag >> config.toMsg)
                , Draggable.onDragEnd (config.toMsg StopDrag)
                ]
    in
        model
            |> Draggable.update dragConfig msg
            |> Tuple.mapSecond React.cmd


onDragging : Float -> Float -> Model -> UpdateResponse msg
onDragging x y model =
    case getDragging model of
        Just windowId ->
            withWindow windowId model (move x y >> React.update)

        Nothing ->
            React.update model


updateApp : Config msg -> AppId -> AppMsg -> Model -> UpdateResponse msg
updateApp config appId appMsg model =
    let
        maybeApp =
            getApp appId model

        maybeWindowId =
            Maybe.map getWindowId maybeApp

        maybeWindow =
            Maybe.andThen (flip getWindow model) maybeWindowId

        maybeActiveServer =
            Maybe.andThen (getAppActiveServer config) maybeApp

        maybeActiveGateway =
            Maybe.andThen (getWindowGateway config model) maybeWindow

        uncurried =
            case Maybe.uncurry maybeActiveServer maybeActiveGateway of
                Just ( active, gateway ) ->
                    case maybeApp of
                        Just app ->
                            Just ( app, active, gateway )

                        Nothing ->
                            Nothing

                Nothing ->
                    Nothing
    in
        case uncurried of
            Just ( app, active, gateway ) ->
                let
                    ( appModel, react ) =
                        updateAppDelegate config
                            active
                            gateway
                            appMsg
                            appId
                            app
                in
                    ( insertApp appId (setModel appModel app) model
                    , react
                    )

            Nothing ->
                React.update model


updateAppDelegate :
    Config msg
    -> ( CId, Server )
    -> ( CId, Server )
    -> AppMsg
    -> AppId
    -> App
    -> ( AppModel, React msg )
updateAppDelegate config ( cid, server ) ( gCid, gServer ) appMsg appId app =
    -- HACK : Elm's Tuple Pattern Matching is slow
    -- https://groups.google.com/forum/#!topic/elm-dev/QGmwWH6V8-c
    case appMsg of
        BackFlixMsg msg ->
            case getModel app of
                BackFlixModel appModel ->
                    appModel
                        |> BackFlix.update (backFlixConfig appId config) msg
                        |> Tuple.mapFirst BackFlixModel

                model ->
                    React.update model

        BounceManagerMsg msg ->
            case getModel app of
                BounceManagerModel appModel ->
                    appModel
                        |> BounceManager.update
                            (bounceManagerConfig appId config)
                            msg
                        |> Tuple.mapFirst BounceManagerModel

                model ->
                    React.update model

        BrowserMsg msg ->
            case getModel app of
                BrowserModel appModel ->
                    appModel
                        |> Browser.update (browserConfig appId cid server config)
                            msg
                        |> Tuple.mapFirst BrowserModel

                model ->
                    React.update model

        BugMsg msg ->
            case getModel app of
                BugModel appModel ->
                    appModel
                        |> Bug.update (bugConfig appId config) msg
                        |> Tuple.mapFirst BugModel

                model ->
                    React.update model

        CalculatorMsg msg ->
            case getModel app of
                CalculatorModel appModel ->
                    appModel
                        |> Calculator.update (calculatorConfig appId config)
                            msg
                        |> Tuple.mapFirst CalculatorModel

                model ->
                    React.update model

        ConnManagerMsg msg ->
            case getModel app of
                ConnManagerModel appModel ->
                    appModel
                        |> ConnManager.update (connManagerConfig appId config)
                            msg
                        |> Tuple.mapFirst ConnManagerModel

                model ->
                    React.update model

        DBAdminMsg msg ->
            case getModel app of
                DatabaseModel appModel ->
                    appModel
                        |> DBAdmin.update (dbAdminConfig appId config) msg
                        |> Tuple.mapFirst DatabaseModel

                model ->
                    React.update model

        EmailMsg msg ->
            case getModel app of
                EmailModel appModel ->
                    appModel
                        |> Email.update (emailConfig appId config) msg
                        |> Tuple.mapFirst EmailModel

                model ->
                    React.update model

        ExplorerMsg msg ->
            case getModel app of
                ExplorerModel appModel ->
                    appModel
                        |> Explorer.update
                            (explorerConfig appId cid server config)
                            msg
                        |> Tuple.mapFirst ExplorerModel

                model ->
                    React.update model

        FinanceMsg msg ->
            case getModel app of
                FinanceModel appModel ->
                    appModel
                        |> Finance.update (financeConfig appId config) msg
                        |> Tuple.mapFirst FinanceModel

                model ->
                    React.update model

        FloatingHeadsMsg msg ->
            case getModel app of
                FloatingHeadsModel appModel ->
                    appModel
                        |> FloatingHeads.update
                            (floatingHeadsConfig (getWindowId app) appId config)
                            msg
                        |> Tuple.mapFirst FloatingHeadsModel

                model ->
                    React.update model

        HebampMsg msg ->
            case getModel app of
                MusicModel appModel ->
                    appModel
                        |> Hebamp.update
                            (hebampConfig (getWindowId app) appId config)
                            msg
                        |> Tuple.mapFirst MusicModel

                model ->
                    React.update model

        LocationPickerMsg msg ->
            case getModel app of
                LocationPickerModel appModel ->
                    appModel
                        |> LocationPicker.update
                            (locationPickerConfig appId config)
                            msg
                        |> Tuple.mapFirst LocationPickerModel

                model ->
                    React.update model

        LogViewerMsg msg ->
            case getModel app of
                LogViewerModel appModel ->
                    appModel
                        |> LogViewer.update
                            (logViewerConfig appId cid server config)
                            msg
                        |> Tuple.mapFirst LogViewerModel

                model ->
                    React.update model

        ServersGearsMsg msg ->
            case getModel app of
                ServersGearsModel appModel ->
                    appModel
                        |> ServersGears.update
                            (serversGearsConfig appId cid server config)
                            msg
                        |> Tuple.mapFirst ServersGearsModel

                model ->
                    React.update model

        TaskManagerMsg msg ->
            case getModel app of
                TaskManagerModel appModel ->
                    appModel
                        |> TaskManager.update
                            (taskManagerConfig appId cid server config)
                            msg
                        |> Tuple.mapFirst TaskManagerModel

                model ->
                    React.update model


updateApps : Config msg -> AppMsg -> Model -> UpdateResponse msg
updateApps config appMsg model =
    React.update model
