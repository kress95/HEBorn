module OS.WindowManager.View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes as Attributes exposing (style, attribute, tabindex)
import Html.Events exposing (onMouseDown)
import Html.Keyed
import Html.CssHelpers
import Css exposing (left, top, asPairs, px, int, zIndex)
import Draggable
import Utils.Html.Attributes exposing (appAttr, boolAttr, activeContextAttr)
import Utils.Html.Events exposing (onClickMe, onKeyDown)
import Apps.Models as Apps
import Apps.BackFlix.View as BackFlix
import Apps.BounceManager.View as BounceManager
import Apps.Browser.View as Browser
import Apps.Bug.View as Bug
import Apps.Calculator.View as Calculator
import Apps.Calculator.Messages as Calculator
import Apps.ConnManager.View as ConnManager
import Apps.CtrlPanel.View as CtrlPanel
import Apps.DBAdmin.View as Database
import Apps.Email.View as Email
import Apps.Explorer.View as Explorer
import Apps.Finance.View as Finance
import Apps.FloatingHeads.View as FloatingHeads
import Apps.Hebamp.View as Hebamp
import Apps.LanViewer.View as LanViewer
import Apps.LocationPicker.View as LocationPicker
import Apps.LogViewer.View as LogViewer
import Apps.ServersGears.View as ServersGears
import Apps.TaskManager.View as TaskManager
import Game.Meta.Types.Context as Context exposing (Context(..))
import OS.Resources as OsRes
import OS.WindowManager.Dock.View as Dock
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Helpers exposing (..)
import OS.WindowManager.Resources as Res
import OS.WindowManager.Shared exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)


view : Config msg -> Model -> Html msg
view config model =
    let
        session =
            getSession (getSessionId config) model
    in
        div [ osClass [ OsRes.Session ] ]
            [ viewSession config model session

            -- sadly, using lazy here will cause problems with window titles
            , Dock.view (dockConfig config) model session
            ]



-- internals


{ id, class, classList } =
    Html.CssHelpers.withNamespace Res.prefix


osClass : List class -> Attribute msg
osClass =
    .class <| Html.CssHelpers.withNamespace OsRes.prefix


windowManagerClass : List class -> Attribute msg
windowManagerClass =
    .class <| Html.CssHelpers.withNamespace Res.prefix


styles : List Css.Style -> Attribute msg
styles =
    Css.asPairs >> style



-- session handling


viewSession : Config msg -> Model -> Session -> Html msg
viewSession config model { visible, focusing } =
    let
        mapFun windowId =
            model
                |> getWindow windowId
                |> Maybe.map (viewWindow config model)
                |> Maybe.withDefault (text "")
                |> (,) windowId
    in
        Html.Keyed.node Res.workspaceNode [ class [ Res.Super ] ] <|
            List.map mapFun visible



-- window decoration and state handling


viewWindow : Config msg -> Model -> Window -> Html msg
viewWindow config model window =
    let
        appId =
            getActiveAppId window

        maybeApp =
            getApp appId model

        maybeAppModel =
            Maybe.map getModel maybeApp

        needsDecoration =
            -- WIP
            case maybeAppModel of
                Just appModel ->
                    True

                Nothing ->
                    True
    in
        case maybeApp of
            Just app ->
                if needsDecoration then
                    windowWrapper config model app window <|
                        viewApp config appId app
                else
                    viewApp config appId app

            Nothing ->
                text ""


windowWrapper : Config msg -> Model -> App -> Window -> Html msg -> Html msg
windowWrapper config model app window html =
    let
        appModel =
            getModel app

        hasDecorations =
            isDecorated <| getModel app

        resizable =
            isResizable <| getModel app

        onMouseDownMsg =
            config.toMsg <| UpdateFocus (Just <| getWindowId app)

        onKeyDownMsg =
            getKeyloggerMsg config (getActiveAppId window) appModel

        attrs =
            [ windowClasses window
            , windowPositionAndSize hasDecorations window
            , decoratedAttr hasDecorations
            , appAttr_ appModel
            , activeContextAttr <| getContext window
            , onMouseDown onMouseDownMsg
            , onKeyDown onKeyDownMsg
            ]

        title =
            Apps.title appModel

        icon =
            Apps.icon <| Apps.toDesktopApp appModel

        content =
            --div [ class [ Res.WindowBody ] ] [ view ]
            text ""
    in
        if hasDecorations then
            div attrs
                [ header config title icon resizable (getWindowId app) window
                , content
                ]
        else
            div attrs
                [ content ]


header :
    Config msg
    -> String
    -> String
    -> Bool
    -> WindowId
    -> Window
    -> Html msg
header config title icon resizable windowId window =
    div
        [ Draggable.mouseTrigger windowId (DragMsg >> config.toMsg)
        , class [ Res.HeaderSuper ]
        ]
        [ div
            [ class [ Res.WindowHeader ]
            , onMouseDown (config.toMsg <| UpdateFocus (Just windowId))
            ]
            [ headerTitle title icon
            , headerContext config windowId window
            , headerButtons config resizable windowId
            ]
        ]


headerTitle : String -> String -> Html msg
headerTitle title icon =
    div
        [ class [ Res.HeaderTitle ]
        , appIconAttr icon
        ]
        [ text title ]


headerContext : Config msg -> WindowId -> Window -> Html msg
headerContext config windowId window =
    let
        content =
            if hasMultipleContext window then
                span
                    [ class [ Res.HeaderContextSw ]
                    , onClickMe <| config.toMsg (ToggleContext windowId)
                    ]
                    [ text <| Context.toString (getContext window) ]
            else
                text ""
    in
        div [] [ content ]


headerButtons : Config msg -> Bool -> WindowId -> Html msg
headerButtons config resizable windowId =
    let
        minimize =
            span
                [ class [ Res.HeaderButton, Res.HeaderBtnMinimize ]
                , onClickMe <| config.toMsg (Minimize windowId)
                ]
                []

        maximize =
            if resizable then
                span
                    [ class [ Res.HeaderButton, Res.HeaderBtnMaximize ]
                    , onClickMe <| config.toMsg (ToggleMaximize windowId)
                    ]
                    []
            else
                text ""

        close =
            span
                [ class [ Res.HeaderButton, Res.HeaderBtnClose ]
                , onClickMe <| config.toMsg (Close windowId)
                ]
                []
    in
        div [ class [ Res.HeaderButtons ] ]
            [ minimize
            , maximize
            , close
            ]


windowClasses : Window -> Attribute msg
windowClasses window =
    if isMaximized window then
        class
            [ Res.Window
            , Res.Maximizeme
            ]
    else
        class [ Res.Window ]


windowPositionAndSize : Bool -> Window -> Html.Attribute msg
windowPositionAndSize hasDecorations window =
    let
        { x, y } =
            getPosition window

        { width, height } =
            getSize window

        position =
            [ left <| px x
            , top <| px y
            ]

        size =
            [ Css.width <| px width
            , Css.height <| px height
            ]

        attrs =
            if hasDecorations then
                position ++ size
            else
                position
    in
        styles attrs


decoratedAttr : Bool -> Html.Attribute msg
decoratedAttr =
    boolAttr Res.decoratedAttrTag



-- integrate with apps


viewApp : Config msg -> AppId -> App -> Html msg
viewApp config appId app =
    let
        appModel =
            getModel app

        --server =
        --    case getAppContext app of
        --        Gateway ->
        --            config.activeGateway
        --        Endpoint ->
    in
        case appModel of
            Apps.LogViewerModel appModel ->
                --LogViewer.view (logViewerConfig appId config) appModel
                text ""

            Apps.TaskManagerModel appModel ->
                --TaskManager.view (taskManagerConfig appId config) appModel
                text ""

            Apps.BrowserModel appModel ->
                --Browser.view (browserConfig appId config) appModel
                text ""

            Apps.ExplorerModel appModel ->
                --Explorer.view (explorerConfig appId config) appModel
                text ""

            Apps.DatabaseModel appModel ->
                --Database.view (databaseConfig appId config) appModel
                text ""

            Apps.ConnManagerModel appModel ->
                --ConnManager.view (connManagerConfig appId config) appModel
                text ""

            Apps.BounceManagerModel appModel ->
                --BounceManager.view (bounceManagerConfig appId config) appModel
                text ""

            Apps.FinanceModel appModel ->
                --Finance.view (financeConfig appId config) appModel
                text ""

            Apps.MusicModel appModel ->
                --Music.view (musicConfig appId config) appModel
                text ""

            Apps.CtrlPanelModel appModel ->
                --CtrlPanel.view (ctrlPanelConfig appId config) appModel
                text ""

            Apps.ServersGearsModel appModel ->
                --ServersGears.view (serversGearsConfig appId config) appModel
                text ""

            Apps.LocationPickerModel appModel ->
                --LocationPicker.view (locationPickerConfig appId config) appModel
                text ""

            Apps.LanViewerModel appModel ->
                --LanViewer.view (lanViewerConfig appId config) appModel
                text ""

            Apps.EmailModel appModel ->
                --Email.view (emailConfig appId config) appModel
                text ""

            Apps.BugModel appModel ->
                --Bug.view  (bugConfig appId config) appModel
                text ""

            Apps.CalculatorModel appModel ->
                --Calculator.view (calculatorConfig appId config) appModel
                text ""

            Apps.BackFlixModel appModel ->
                --BackFlix.view (backFlixConfig appId config) appModel
                text ""

            Apps.FloatingHeadsModel appModel ->
                --FloatingHeads.view (floatingHeadsConfig appId config) appModel
                text ""


isDecorated : Apps.AppModel -> Bool
isDecorated app =
    case app of
        Apps.MusicModel _ ->
            False

        Apps.FloatingHeadsModel _ ->
            False

        _ ->
            True


isResizable : Apps.AppModel -> Bool
isResizable app =
    case app of
        Apps.EmailModel _ ->
            False

        Apps.MusicModel _ ->
            False

        _ ->
            True


getKeyloggerMsg : Config msg -> AppId -> Apps.AppModel -> (Int -> msg)
getKeyloggerMsg config appId app =
    case app of
        Apps.CalculatorModel _ ->
            Calculator.KeyMsg >> CalculatorMsg appId >> config.toMsg

        _ ->
            always <| config.batchMsg []


appAttr_ : Apps.AppModel -> Attribute msg
appAttr_ =
    Apps.toDesktopApp >> Apps.name >> appAttr


appIconAttr : String -> Attribute msg
appIconAttr =
    attribute Res.appIconAttrTag
