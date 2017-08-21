module Game.Missions.Update exposing (update)

import Core.Dispatch as Dispatch exposing (Dispatch)
import Game.Models as Game
import Game.Missions.Messages exposing (..)
import Game.Missions.Models exposing (..)
import Apps.Messages as Apps


update : Game.Model -> Msg -> Model -> ( Model, Cmd Msg, Dispatch )
update game msg model =
    case Debug.log "<><><> GOT MSG <><><>" msg of
        _ ->
            ( model, Cmd.none, Dispatch.none )
