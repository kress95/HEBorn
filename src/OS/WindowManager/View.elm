module OS.WindowManager.View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes as Attributes exposing (style, attribute, tabindex)
import Html.Events exposing (onMouseDown)
import Html.Keyed
import Html.CssHelpers
import Css exposing (left, top, asPairs, px, height, width, int, zIndex)
import Draggable
import Utils.Html.Attributes exposing (appAttr, boolAttr, activeContextAttr)
import Utils.Html.Events exposing (onClickMe, onKeyDown)
import Apps.Models as Apps
import Apps.View as Apps
import Game.Meta.Types.Context exposing (..)
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
            config
                |> getSessionId
                |> flip getSession model
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


viewWindow : Config msg -> Model -> Window -> Html msg
viewWindow config model window =
    div [] []


viewApp : Config msg -> AppId -> App -> Html msg
viewApp config appId app =
    div [] []
