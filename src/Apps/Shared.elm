module Apps.Shared exposing (..)

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


type AppContexts
    = ContextualApp
    | ContextlessApp


contexts : DesktopApp -> AppContexts
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
