module OS.SessionManager.Dock.View exposing (view)

import OS.SessionManager.Dock.Messages exposing (..)
import OS.SessionManager.Models as SessionManager exposing (WindowRef)
import Dict exposing (Dict)
import Html exposing (Html, div, text, button, ul, li, hr)
import Html.Events exposing (onClick)
import Html.Attributes exposing (attribute)
import Html.CssHelpers
import Utils exposing (andThenWithDefault)
import Core.Messages exposing (CoreMsg(..))
import Core.Models exposing (CoreModel)
import OS.Messages exposing (OSMsg(..))
import OS.SessionManager.WindowManager.Messages as WindowManager
import OS.SessionManager.WindowManager.Models as WindowManager
-- import OS.SessionManager.WindowManager.View exposing (windowTitle)
-- import OS.Dock.Style as Css
import Apps.Models as Apps
import Game.Models exposing (GameModel)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "dock"


type alias Applications =
    List ( Apps.App, List WindowRef )


view : GameModel -> SessionManager.Model -> Html Msg
view game model =
    renderApplications game model


renderApplications : GameModel -> SessionManager.Model -> Html Msg
renderApplications game model =
    div [] []


getApplications : GameModel -> SessionManager.Model -> Applications
getApplications game model =
    -- This function should create an app list from the current
    -- server "list of apps" and also from session windows
    [ ( Apps.LogViewerApp, [ ( "", "" ) ] ) ]



{--

view : CoreModel -> Html CoreMsg
view model =
    renderApplications model


renderApplications : CoreModel -> Html CoreMsg
renderApplications model =
    let
        applications =
            getApplications model.os.dock

        html =
            List.foldr (\app acc -> [ renderApplication model app ] ++ acc) [] applications
    in
        div [ id Css.DockContainer ]
            [ div
                [ id Css.DockMain ]
                html
            ]


hasInstanceString : Int -> String
hasInstanceString num =
    if (num > 0) then
        "Y"
    else
        "N"


filteredTile : Int -> WindowID -> CoreModel -> String
filteredTile i windowID model =
    (toString i)
        ++ ": "
        ++ (andThenWithDefault
                windowTitle
                "404"
                (getWindow windowID model.os.wm)
           )


renderApplicationSubmenu : CoreModel -> Application -> Html CoreMsg
renderApplicationSubmenu model application =
    div
        [ class [ Css.DockAppContext ]
        , onClick (MsgOS OS.Messages.NoOp)
        ]
        [ ul []
            ([ li [] [ text "OPEN WINDOWS" ] ]
                ++ (List.indexedMap
                        (\i windowID ->
                            li
                                [ class [ Css.ClickableWindow ]
                                , attribute "data-id" windowID
                                , onClick (MsgOS (MsgWM (UpdateFocusTo (Just windowID))))
                                ]
                                [ text (filteredTile i windowID model) ]
                        )
                        application.openWindows
                   )
                ++ [ hr [] []
                   , li [] [ text "MINIMIZED LINUXES" ]
                   ]
                ++ (List.indexedMap
                        (\i windowID ->
                            li
                                [ class [ Css.ClickableWindow ]
                                , attribute "data-id" windowID
                                , onClick (MsgOS (MsgWM (Restore windowID)))
                                ]
                                [ text (filteredTile i windowID model) ]
                        )
                        application.minimizedWindows
                   )
                ++ [ hr [] []
                   , li
                        [ class [ Css.ClickableWindow ]
                        , onClick (MsgOS (MsgWM (Open application.app)))
                        ]
                        [ text "New window" ]
                   , li
                        [ class [ Css.ClickableWindow ]
                        , onClick (MsgOS (MsgWM (MinimizeAll application.app)))
                        ]
                        [ text "Minimize all" ]
                   , li
                        [ class [ Css.ClickableWindow ]
                        , onClick (MsgOS (MsgWM (CloseAll application.app)))
                        ]
                        [ text "Close all" ]
                   ]
            )
        ]


renderApplication : CoreModel -> Application -> Html CoreMsg
renderApplication model application =
    div
        [ class [ Css.Item ]
        , attribute "data-hasinst" (hasInstanceString application.instancesNum)
        ]
        ([ div
            [ class [ Css.ItemIco ]
            , onClick (MsgOS (MsgWM (OpenOrRestore application.app)))
            , attribute "data-icon" (Apps.icon application.app)
            ]
            []
         ]
            ++ (if application.instancesNum > 0 then
                    [ renderApplicationSubmenu model application ]
                else
                    []
               )
        )
--}
