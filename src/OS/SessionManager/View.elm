module OS.SessionManager.View exposing (..)

import OS.SessionManager.Models exposing (..)
import OS.SessionManager.Messages exposing (..)
import Html exposing (..)
import Game.Models exposing (GameModel)
import OS.SessionManager.WindowManager.View as WindowManager
import OS.SessionManager.Dock.View as Dock


view : GameModel -> Model -> Html Msg
view game model =
    div []
        [ wm game model
        , dock game model
        ]



-- internals


dock : GameModel -> Model -> Html Msg
dock game model =
    model
        |> Dock.view game
        |> Html.map DockMsg


wm : GameModel -> Model -> Html Msg
wm game model =
    let
        html =
            model
                |> windows
                |> List.foldr (windowRefReducer game model) []
    in
        div [] html

windowRefReducer
    : GameModel
    -> Model
    -> WindowRef
    -> List (Html Msg)
    -> List (Html Msg)
windowRefReducer game model ( wmID, id ) xs =
    case getWindowManager wmID model of
        Just wm ->
            wm
                |> WindowManager.renderWindow id game
                |> Html.map (WindowManagerMsg wmID)
                |> flip (::) xs

        Nothing ->
            xs
