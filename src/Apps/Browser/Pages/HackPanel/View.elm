module Apps.Browser.Pages.HackPanel.View exposing (view)

import Game.Data as Game
import Apps.Browser.Pages.HackPanel.Messages exposing (..)
import Apps.Browser.Pages.HackPanel.Models exposing (..)
import Html exposing (Html, div, text)


view : Game.Data -> Model -> Html Msg
view data model =
    div []
        [ text "Login" ]
        []
