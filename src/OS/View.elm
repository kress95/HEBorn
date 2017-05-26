module OS.View exposing (view)

import OS.Models exposing (..)
import OS.Messages exposing (..)
import OS.Style as Css
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Router.Router exposing (Route(..))
import Core.Models exposing (CoreModel)
import Core.Messages exposing (CoreMsg(..))
import Game.Models exposing (GameModel)
import OS.Header.View as Header
import OS.Menu.View exposing (menuView, menuEmpty)
import OS.SessionManager.View as SessionManager
import OS.SessionManager.Messages as SessionManager


-- this module should return OSMsgs instead of CoreMsg


{ id, class, classList } =
    Html.CssHelpers.withNamespace "os"


view : CoreModel -> Html CoreMsg
view model =
    div
        [ id Css.Dashboard
        , menuEmpty
        ]
        [ viewHeader model.game model.os
        , viewMain model.game model.os
        , viewFooter model
        , menuView model.os
        ]


viewHeader : GameModel -> Model -> Html CoreMsg
viewHeader game model =
    header []
        [ (Header.view game model.header) ]


viewMain : GameModel -> Model -> Html CoreMsg
viewMain game model =
    model.session
        |> SessionManager.view game
        |> Html.map SessionManagerMsg
        |> Html.map MsgOS


viewFooter : CoreModel -> Html CoreMsg
viewFooter model =
    footer []
        [ displayVersion model.config.version
        ]


displayVersion : String -> Html CoreMsg
displayVersion version =
    div [ id Css.DesktopVersion ]
        [ text version ]
