module Apps.Hebamp.Launch exposing (..)

import Utils.React as React exposing (React)
import Game.Meta.Types.Apps.Desktop exposing (Reference)
import Apps.Hebamp.Config exposing (..)
import Apps.Hebamp.Models exposing (..)
import Apps.Hebamp.Shared exposing (..)


type alias LaunchResponse msg =
    ( Model, React msg )


launch : Config msg -> Maybe Params -> Reference -> LaunchResponse msg
launch config maybeParams reference =
    case maybeParams of
        Just (OpenPlaylist playlist) ->
            launchOpenPlaylist config playlist reference

        Nothing ->
            ( initialModel reference [], React.none )


launchOpenPlaylist : Config msg -> List AudioData -> Reference -> LaunchResponse msg
launchOpenPlaylist _ playlist reference =
    let
        model =
            initialModel reference playlist
    in
        ( model, React.none )
