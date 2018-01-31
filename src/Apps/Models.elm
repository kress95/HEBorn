module Apps.Models
    exposing
        ( AppModel(..)
        , Contexts(..)
        , toDesktopApp
        , contexts
        , name
        , title
        , icon
        , windowInitSize
        )

import Game.Meta.Types.Apps.Desktop as DesktopApp exposing (DesktopApp)
import Apps.LogViewer.Models as LogViewer
import Apps.TaskManager.Models as TaskManager
import Apps.Browser.Models as Browser
import Apps.Explorer.Models as Explorer
import Apps.DBAdmin.Models as Database
import Apps.ConnManager.Models as ConnManager
import Apps.BounceManager.Models as BounceManager
import Apps.Finance.Models as Finance
import Apps.Hebamp.Models as Hebamp
import Apps.CtrlPanel.Models as CtrlPanel
import Apps.ServersGears.Models as ServersGears
import Apps.LocationPicker.Models as LocationPicker
import Apps.LanViewer.Models as LanViewer
import Apps.Email.Models as Email
import Apps.Bug.Models as Bug
import Apps.Calculator.Models as Calculator
import Apps.BackFlix.Models as BackFlix
import Apps.FloatingHeads.Models as FloatingHeads


type AppModel
    = LogViewerModel LogViewer.Model
    | TaskManagerModel TaskManager.Model
    | BrowserModel Browser.Model
    | ExplorerModel Explorer.Model
    | DatabaseModel Database.Model
    | ConnManagerModel ConnManager.Model
    | BounceManagerModel BounceManager.Model
    | FinanceModel Finance.Model
    | MusicModel Hebamp.Model
    | CtrlPanelModel CtrlPanel.Model
    | ServersGearsModel ServersGears.Model
    | LocationPickerModel LocationPicker.Model
    | LanViewerModel LanViewer.Model
    | EmailModel Email.Model
    | BugModel Bug.Model
    | CalculatorModel Calculator.Model
    | BackFlixModel BackFlix.Model
    | FloatingHeadsModel FloatingHeads.Model


type Contexts
    = ContextualApp
    | ContextlessApp


toDesktopApp : AppModel -> DesktopApp
toDesktopApp model =
    case model of
        LogViewerModel _ ->
            DesktopApp.LogViewer

        TaskManagerModel _ ->
            DesktopApp.TaskManager

        BrowserModel _ ->
            DesktopApp.Browser

        ExplorerModel _ ->
            DesktopApp.Explorer

        DatabaseModel _ ->
            DesktopApp.Database

        ConnManagerModel _ ->
            DesktopApp.ConnManager

        BounceManagerModel _ ->
            DesktopApp.BounceManager

        FinanceModel _ ->
            DesktopApp.Finance

        MusicModel _ ->
            DesktopApp.Hebamp

        CtrlPanelModel _ ->
            DesktopApp.CtrlPanel

        ServersGearsModel _ ->
            DesktopApp.ServersGears

        LocationPickerModel _ ->
            DesktopApp.LocationPicker

        LanViewerModel _ ->
            DesktopApp.LanViewer

        EmailModel _ ->
            DesktopApp.Email

        BugModel _ ->
            DesktopApp.Bug

        CalculatorModel _ ->
            DesktopApp.Calculator

        BackFlixModel _ ->
            DesktopApp.BackFlix

        FloatingHeadsModel _ ->
            DesktopApp.FloatingHeads


contexts : DesktopApp -> Contexts
contexts app =
    case app of
        DesktopApp.LogViewer ->
            ContextualApp

        DesktopApp.TaskManager ->
            ContextualApp

        DesktopApp.Browser ->
            ContextualApp

        DesktopApp.Explorer ->
            ContextualApp

        DesktopApp.Database ->
            ContextlessApp

        DesktopApp.ConnManager ->
            ContextlessApp

        DesktopApp.BounceManager ->
            ContextlessApp

        DesktopApp.Finance ->
            ContextlessApp

        DesktopApp.Hebamp ->
            ContextlessApp

        DesktopApp.CtrlPanel ->
            ContextlessApp

        DesktopApp.ServersGears ->
            ContextlessApp

        DesktopApp.LocationPicker ->
            ContextlessApp

        DesktopApp.LanViewer ->
            ContextualApp

        DesktopApp.Email ->
            ContextlessApp

        DesktopApp.Bug ->
            ContextualApp

        DesktopApp.Calculator ->
            ContextlessApp

        DesktopApp.BackFlix ->
            ContextlessApp

        DesktopApp.FloatingHeads ->
            ContextlessApp


name : DesktopApp -> String
name app =
    case app of
        DesktopApp.LogViewer ->
            LogViewer.name

        DesktopApp.TaskManager ->
            TaskManager.name

        DesktopApp.Browser ->
            Browser.name

        DesktopApp.Explorer ->
            Explorer.name

        DesktopApp.Database ->
            Database.name

        DesktopApp.ConnManager ->
            ConnManager.name

        DesktopApp.BounceManager ->
            BounceManager.name

        DesktopApp.Finance ->
            Finance.name

        DesktopApp.Hebamp ->
            Hebamp.name

        DesktopApp.CtrlPanel ->
            CtrlPanel.name

        DesktopApp.ServersGears ->
            ServersGears.name

        DesktopApp.LocationPicker ->
            LocationPicker.name

        DesktopApp.LanViewer ->
            LanViewer.name

        DesktopApp.Email ->
            Email.name

        DesktopApp.Bug ->
            Bug.name

        DesktopApp.Calculator ->
            Calculator.name

        DesktopApp.BackFlix ->
            BackFlix.name

        DesktopApp.FloatingHeads ->
            FloatingHeads.name


icon : DesktopApp -> String
icon app =
    case app of
        DesktopApp.LogViewer ->
            LogViewer.icon

        DesktopApp.TaskManager ->
            TaskManager.icon

        DesktopApp.Browser ->
            Browser.icon

        DesktopApp.Explorer ->
            Explorer.icon

        DesktopApp.Database ->
            Database.icon

        DesktopApp.ConnManager ->
            ConnManager.icon

        DesktopApp.BounceManager ->
            BounceManager.icon

        DesktopApp.Finance ->
            Finance.icon

        DesktopApp.Hebamp ->
            Hebamp.icon

        DesktopApp.CtrlPanel ->
            CtrlPanel.icon

        DesktopApp.ServersGears ->
            ServersGears.icon

        DesktopApp.LocationPicker ->
            LocationPicker.icon

        DesktopApp.LanViewer ->
            LanViewer.icon

        DesktopApp.Email ->
            Email.icon

        DesktopApp.Bug ->
            Bug.icon

        DesktopApp.Calculator ->
            Calculator.icon

        DesktopApp.BackFlix ->
            BackFlix.icon

        DesktopApp.FloatingHeads ->
            FloatingHeads.icon


title : AppModel -> String
title model =
    case model of
        LogViewerModel model ->
            LogViewer.title model

        TaskManagerModel model ->
            TaskManager.title model

        BrowserModel model ->
            Browser.title model

        ExplorerModel model ->
            Explorer.title model

        DatabaseModel model ->
            Database.title model

        ConnManagerModel model ->
            ConnManager.title model

        BounceManagerModel model ->
            BounceManager.title model

        FinanceModel model ->
            Finance.title model

        MusicModel model ->
            Hebamp.title model

        CtrlPanelModel model ->
            CtrlPanel.title model

        ServersGearsModel model ->
            ServersGears.title model

        LocationPickerModel model ->
            LocationPicker.title model

        LanViewerModel model ->
            LanViewer.title model

        EmailModel model ->
            Email.title model

        BugModel model ->
            Bug.title model

        CalculatorModel model ->
            Calculator.title model

        BackFlixModel model ->
            BackFlix.title model

        FloatingHeadsModel model ->
            FloatingHeads.title model


windowInitSize : DesktopApp -> ( Float, Float )
windowInitSize app =
    case app of
        DesktopApp.Email ->
            Email.windowInitSize

        DesktopApp.Browser ->
            Browser.windowInitSize

        DesktopApp.Calculator ->
            Calculator.windowInitSize

        DesktopApp.BackFlix ->
            BackFlix.windowInitSize

        _ ->
            ( 600, 400 )
