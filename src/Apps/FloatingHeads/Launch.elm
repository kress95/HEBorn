module Apps.FloatingHeads.Launch exposing (..)

import Utils.React as React exposing (React)
import Game.Meta.Types.Apps.Desktop exposing (Reference)
import Apps.FloatingHeads.Config exposing (..)
import Apps.FloatingHeads.Models exposing (..)


type alias LaunchResponse msg =
    ( Model, React msg )


launch : Config msg -> Maybe Params -> Reference -> LaunchResponse msg
launch config maybeParams me =
    case maybeParams of
        Just (OpenAtContact contact) ->
            launchOpenAtContact config contact me

        Nothing ->
            ( initialModel Nothing me, React.none )


launchOpenAtContact : Config msg -> String -> Reference -> LaunchResponse msg
launchOpenAtContact config contact me =
    let
        model =
            initialModel (Just contact) me
    in
        ( model, React.none )
