module Core.Dispatch
    exposing
        ( Dispatch
        , batch
        , none
        , foldl
        , foldr
        , fromList
        , toList
        , toCmd
        , core
        , websocket
        , game
        , account
        , servers
        , web
        , missionsFromApps
        , missionsFromHeader
        , missionsFromDock
        , server
        , filesystem
        , processes
        , logs
        , log
        , tunnels
        , meta
        )

import Core.Messages exposing (..)
import Driver.Websocket.Messages as Ws
import Game.Messages as Game
import Game.Meta.Messages as Meta
import Game.Web.Messages as Web
import Game.Account.Messages as Account
import Game.Servers.Messages as Servers
import Game.Servers.Filesystem.Messages as Filesystem
import Game.Servers.Processes.Messages as Processes
import Game.Servers.Logs.Messages as Logs
import Game.Servers.Logs.Models as Logs
import Game.Servers.Tunnels.Messages as Tunnels
import Game.Servers.Shared as Servers
import Utils.Cmd as CmdUtils
import Apps.Messages as Apps
import Game.Missions.Messages as Missions
import OS.Header.Messages as Header
import OS.SessionManager.Dock.Messages as Dock


-- opaque type to hide the dispatch magic


type Dispatch
    = Many (List Msg)
    | One Msg
    | None



-- cmd/sub like interface


batch : List Dispatch -> Dispatch
batch list =
    -- tried to make it as fast a possible
    case List.head list of
        Just accum ->
            case List.tail list of
                Just iter ->
                    -- this function **may** need to change into a foldr
                    fromList <| List.foldl reducer (toList accum) iter

                Nothing ->
                    accum

        Nothing ->
            None


none : Dispatch
none =
    None



-- reducers


foldl : (Msg -> acc -> acc) -> acc -> Dispatch -> acc
foldl fun init dispatch =
    case dispatch of
        Many list ->
            List.foldl fun init list

        One msg ->
            fun msg init

        None ->
            init


foldr : (Msg -> acc -> acc) -> acc -> Dispatch -> acc
foldr fun init dispatch =
    case dispatch of
        Many list ->
            List.foldr fun init list

        One msg ->
            fun msg init

        None ->
            init



-- reveals some of the magic (try not using this a lot)


fromList : List Msg -> Dispatch
fromList list =
    case List.head list of
        Just item ->
            case List.tail list of
                Just _ ->
                    Many list

                Nothing ->
                    One item

        Nothing ->
            None


toList : Dispatch -> List Msg
toList dispatch =
    case dispatch of
        Many list ->
            list

        One msg ->
            [ msg ]

        None ->
            []


toCmd : Dispatch -> Cmd Msg
toCmd dispatch =
    -- TODO: check if reversing is really needed, ordering
    -- must never be a problem
    dispatch
        |> toList
        |> List.reverse
        |> List.map CmdUtils.fromMsg
        |> Cmd.batch



-- dispatchers


core : Msg -> Dispatch
core msg =
    One msg


websocket : Ws.Msg -> Dispatch
websocket msg =
    core <| WebsocketMsg msg


game : Game.Msg -> Dispatch
game msg =
    core <| GameMsg msg


missionsFromApps : Apps.Msg -> Dispatch
missionsFromApps msg =
    game <| Game.MissionsMsg (Missions.AppsMsg msg)


missionsFromHeader : Header.Msg -> Dispatch
missionsFromHeader msg =
    game <| Game.MissionsMsg (Missions.HeaderMsg msg)


missionsFromDock : Dock.Msg -> Dispatch
missionsFromDock msg =
    game <| Game.MissionsMsg (Missions.DockMsg msg)


account : Account.Msg -> Dispatch
account msg =
    game <| Game.AccountMsg msg


servers : Servers.Msg -> Dispatch
servers msg =
    game <| Game.ServersMsg msg


meta : Meta.Msg -> Dispatch
meta msg =
    game <| Game.MetaMsg msg


web : Web.Msg -> Dispatch
web msg =
    game <| Game.WebMsg msg


server : Servers.ID -> Servers.ServerMsg -> Dispatch
server id msg =
    servers <| Servers.ServerMsg id msg


filesystem : Servers.ID -> Filesystem.Msg -> Dispatch
filesystem id msg =
    server id <| Servers.FilesystemMsg msg


processes : Servers.ID -> Processes.Msg -> Dispatch
processes id msg =
    server id <| Servers.ProcessesMsg msg


logs : Servers.ID -> Logs.Msg -> Dispatch
logs id msg =
    server id <| Servers.LogsMsg msg


log : Servers.ID -> Logs.ID -> Logs.LogMsg -> Dispatch
log serverId id msg =
    logs serverId <| Logs.LogMsg id msg


tunnels : Servers.ID -> Tunnels.Msg -> Dispatch
tunnels id msg =
    server id <| Servers.TunnelsMsg msg



-- internals


reducer : Dispatch -> List Msg -> List Msg
reducer next acc =
    case next of
        Many list ->
            List.foldl (::) acc list

        One msg ->
            msg :: acc

        None ->
            acc
