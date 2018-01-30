module OS.WindowManager.View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes as Attributes exposing (style, attribute, tabindex)
import Html.Events exposing (onMouseDown)
import Html.CssHelpers
import Html.Keyed
import Css exposing (left, top, asPairs, px, height, width, int, zIndex)
import Draggable
import Utils.Html.Attributes exposing (appAttr, boolAttr, activeContextAttr)
import Utils.Html.Events exposing (onClickMe, onKeyDown)
import Apps.Models as Apps
import Apps.View as Apps
import Game.Meta.Types.Context exposing (..)
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)


view : Config msg -> Model -> Html msg
view config model =
    div [] []
