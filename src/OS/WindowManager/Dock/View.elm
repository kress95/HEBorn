module OS.WindowManager.Dock.View exposing (view)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (title, attribute)
import Utils.Html.Attributes exposing (..)
import Html.CssHelpers
import Game.Meta.Types.Apps.Desktop as DesktopApp exposing (DesktopApp)
import OS.Resources as OsRes
import Apps.Models as Apps
import OS.WindowManager.Models exposing (..)
import OS.WindowManager.Dock.Config exposing (..)
import OS.WindowManager.Dock.Resources as Res


-- this module still needs a refactor to make its code more maintainable


{ id, class, classList } =
    Html.CssHelpers.withNamespace Res.prefix


osClass : List class -> Attribute msg
osClass =
    .class <| Html.CssHelpers.withNamespace OsRes.prefix


view : Config msg -> Model -> Html msg
view config model =
    div [ osClass [ OsRes.Dock ] ]
        [ dock config model ]



-- internals


dock : Config msg -> Model -> Html msg
dock config model =
    let
        id =
            config.sessionId

        wm =
            Maybe.withDefault (WM.initialModel id) (get id model)

        dock =
            config.accountDock

        content =
            icons config dock wm
    in
        div [ class [ Res.Container ] ]
            [ div [ class [ Res.Main ] ] [ content ] ]


icons : Config msg -> List DesktopApp -> WM.Model -> Html msg
icons config apps wm =
    let
        group =
            WM.group wm

        reducer app acc =
            let
                isNotEmpty =
                    hasAppOpened app group

                item =
                    icon config app group wm

                content =
                    if isNotEmpty then
                        let
                            menu =
                                options config app group
                        in
                            [ item, menu ]
                    else
                        [ item ]

                result =
                    div
                        [ class [ Res.Item ]
                        , appAttr app
                        , boolAttr Res.appHasInstanceAttrTag isNotEmpty
                        ]
                        content
            in
                result :: acc

        content =
            apps
                |> List.foldl reducer []
                |> List.reverse
    in
        div [ class [ Res.Main ] ] content


icon : Config msg -> DesktopApp -> WM.GroupedWindows -> WM.Model -> Html msg
icon config app group wm =
    div
        [ class [ Res.ItemIco ]
        , onClick (config.toMsg <| AppButton app)
        , attribute Res.appIconAttrTag (Apps.icon app)
        , title (Apps.name app)
        ]
        []


options : Config msg -> DesktopApp -> WM.GroupedWindows -> Html msg
options config app { visible, hidden } =
    let
        appName =
            Apps.name app

        separator =
            hr [] []

        defaultToEmptyList =
            Maybe.withDefault []

        visible_ =
            visible
                |> Dict.get appName
                |> defaultToEmptyList
                |> windowList (FocusWindow >> config.toMsg) "OPEN WINDOWS"

        hidden_ =
            hidden
                |> Dict.get appName
                |> defaultToEmptyList
                |> windowList (RestoreWindow >> config.toMsg) "HIDDEN LINUXES"

        batchActions =
            [ subMenuAction "New window" (config.toMsg <| OpenApp app)
            , subMenuAction "Minimize all" (config.toMsg <| MinimizeApps app)
            , subMenuAction "Close all" (config.toMsg <| CloseApps app)
            ]

        menu_ =
            batchActions
                |> (++) hidden_
                |> (::) separator
                |> (++) visible_
    in
        div [ class [ Res.AppContext ] ]
            [ ul [] menu_ ]


hasAppOpened : DesktopApp -> WM.GroupedWindows -> Bool
hasAppOpened app { hidden, visible } =
    let
        name =
            Apps.name app

        notEmpty =
            List.isEmpty >> (not)

        hidden_ =
            hidden
                |> Dict.get name
                |> Maybe.map notEmpty
                |> Maybe.withDefault False

        visible_ =
            visible
                |> Dict.get name
                |> Maybe.map notEmpty
                |> Maybe.withDefault False

        result =
            hidden_ || visible_
    in
        result


subMenuAction : String -> msg -> Html msg
subMenuAction label event =
    li
        [ class [ Res.ClickableWindow ], onClick event ]
        [ text label ]


windowList :
    (String -> msg)
    -> String
    -> List ( String, WM.Window )
    -> List (Html msg)
windowList event label list =
    let
        titleAndID ( id, window ) =
            (WM.title window) ++ id
    in
        list
            |> List.sortBy titleAndID
            |> List.indexedMap (listItem event)
            |> (::) (hr [] [])
            |> (::) (li [] [ text label ])


listItem : (String -> msg) -> Int -> ( String, WM.Window ) -> Html msg
listItem event index ( id, window ) =
    li
        [ class [ Res.ClickableWindow ]
        , idAttr (toString index)
        , onClick (event id)
        ]
        [ (windowLabel index window) ]


windowLabel : Int -> WM.Window -> Html msg
windowLabel index window =
    let
        andThen =
            flip (++)
    in
        index
            |> toString
            |> andThen ": "
            |> andThen (WM.title window)
            |> text
