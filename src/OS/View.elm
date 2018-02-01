module OS.View exposing (view)

import Html as Html exposing (Html, div, text)
import Html.Attributes as Attributes exposing (attribute)
import Html.Lazy exposing (lazy)
import Html.CssHelpers
import Utils.Html.Attributes exposing (activeContextAttr)
import Core.Flags as Flags
import OS.Header.View as Header
import OS.Header.Models as Header
import OS.WindowManager.View as WindowManager
import OS.Toasts.View as Toasts
import OS.Console.View as Console
import OS.DynamicStyle as DynamicStyle
import OS.Resources as Res
import OS.Config exposing (..)
import OS.Models exposing (..)
import OS.Messages exposing (..)


{ id, class, classList } =
    Html.CssHelpers.withNamespace Res.prefix


view : Config msg -> Model -> Html msg
view config model =
    let
        osContent =
            viewOS config model

        dynStyle =
            DynamicStyle.view config

        version =
            config.flags
                |> Flags.getVersion

        context =
            config.activeContext

        story =
            config.story

        gameMode =
            case config.isCampaign of
                True ->
                    Res.campaignMode

                False ->
                    Res.multiplayerMode
    in
        div
            [ id Res.Dashboard
            , attribute Res.gameVersionAttrTag version
            , attribute Res.gameModeAttrTag gameMode
            , activeContextAttr context
            ]
            (dynStyle :: osContent)


viewOS : Config msg -> Model -> List (Html msg)
viewOS config model =
    let
        version =
            config.flags
                |> Flags.getVersion
    in
        [ viewHeader config model.header
        , console config
        , viewMain config model
        , toasts config model
        , lazy displayVersion
            version
        ]


viewHeader : Config msg -> Header.Model -> Html msg
viewHeader config header =
    let
        config_ =
            headerConfig config
    in
        Header.view config_ header
            |> Html.map (HeaderMsg >> config.toMsg)


viewMain : Config msg -> Model -> Html msg
viewMain config model =
    WindowManager.view (windowManagerConfig config) (getWindowManager model)


displayVersion : String -> Html msg
displayVersion version =
    div
        [ class [ Res.Version ] ]
        [ text version ]


toasts : Config msg -> Model -> Html msg
toasts config model =
    model.toasts
        |> Toasts.view
        |> Html.map (ToastsMsg >> config.toMsg)


console : Config msg -> Html msg
console config =
    let
        config_ =
            consoleConfig config
    in
        Console.view config_
