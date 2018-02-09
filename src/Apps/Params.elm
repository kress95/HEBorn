module Apps.Params exposing (..)

import Game.Meta.Types.Apps.Desktop as DesktopApp exposing (DesktopApp)
import Apps.Browser.Models as Browser
import Apps.FloatingHeads.Models as FloatingHeads
import Apps.Hebamp.Shared as Hebamp


type AppParams
    = Browser Browser.Params
    | FloatingHeads FloatingHeads.Params
    | Hebamp Hebamp.Params


toAppType : AppParams -> DesktopApp
toAppType params =
    case params of
        Browser _ ->
            DesktopApp.Browser

        FloatingHeads _ ->
            DesktopApp.FloatingHeads

        Hebamp _ ->
            DesktopApp.Hebamp


castBrowser : AppParams -> Maybe Browser.Params
castBrowser params =
    case params of
        Browser params ->
            Just params

        _ ->
            Nothing


castFloatingHeads : AppParams -> Maybe FloatingHeads.Params
castFloatingHeads params =
    case params of
        FloatingHeads params ->
            Just params

        _ ->
            Nothing


castHebamp : AppParams -> Maybe Hebamp.Params
castHebamp params =
    case params of
        Hebamp params ->
            Just params

        _ ->
            Nothing
