module Game.Servers.Update exposing (..)

import Core.Messages exposing (CoreMsg)
import Driver.Websocket.Reports as Websocket
import Driver.Websocket.Channels as Websocket
import Events.Events as Events
import Game.Messages exposing (GameMsg)
import Game.Models exposing (GameModel)
import Game.Servers.Filesystem.Messages as Filesystem
import Game.Servers.Filesystem.Update as Filesystem
import Game.Servers.Logs.Messages as Logs
import Game.Servers.Logs.Update as Logs
import Game.Servers.Messages exposing (..)
import Game.Servers.Models exposing (..)
import Game.Servers.Processes.Messages as Processes
import Game.Servers.Processes.Update as Processes
import Game.Servers.Requests exposing (..)
import Game.Servers.Requests.LogIndex as LogIndex


update : Msg -> Servers -> GameModel -> ( Servers, Cmd GameMsg, List CoreMsg )
update msg model game =
    case msg of
        MsgFilesystem id msg ->
            filesystem id msg model game

        MsgLog id msg ->
            log id msg model game

        MsgProcess id msg ->
            process id msg model game

        Request data ->
            response (receive data) model game
        
        Event data ->
            event data model game


-- internals


response :
    Response
    -> Servers
    -> GameModel
    -> ( Servers, Cmd GameMsg, List CoreMsg )
response response model game =
    case response of
        _ ->
            ( model, Cmd.none, [] )


filesystem :
    ServerID
    -> Filesystem.Msg
    -> Servers
    -> GameModel
    -> ( Servers, Cmd GameMsg, List CoreMsg )
filesystem id msg model game =
    case (getServerByID model id) of
        StdServer server ->
            let
                ( filesystem_, cmd, msgs ) =
                    Filesystem.update msg server.filesystem game

                server_ =
                    StdServer { server | filesystem = filesystem_ }

                model_ =
                    updateServer model server_
            in
                ( model_, cmd, msgs )

        NoServer ->
            ( model, Cmd.none, [] )


log :
    ServerID
    -> Logs.Msg
    -> Servers
    -> GameModel
    -> ( Servers, Cmd GameMsg, List CoreMsg )
log id msg model game =
    case (getServerByID model id) of
        StdServer server ->
            let
                ( logs_, cmd, msgs ) =
                    Logs.update msg server.logs game

                server_ =
                    StdServer { server | logs = logs_ }

                model_ =
                    updateServer model server_
            in
                ( model_, cmd, msgs )

        NoServer ->
            ( model, Cmd.none, [] )


process :
    ServerID
    -> Processes.Msg
    -> Servers
    -> GameModel
    -> ( Servers, Cmd GameMsg, List CoreMsg )
process id msg model game =
    case (getServerByID model id) of
        StdServer server ->
            let
                ( processes_, cmd, msgs ) =
                    Processes.update msg server.processes game

                server_ =
                    StdServer { server | processes = processes_ }

                model_ =
                    updateServer model server_
            in
                ( model_, cmd, msgs )

        NoServer ->
            ( model, Cmd.none, [] )


event :
    Events.Response
    -> Servers
    -> GameModel
    -> ( Servers, Cmd GameMsg, List CoreMsg )
event ev model game =
    case ev of
        Events.Report (Websocket.Joined Websocket.ServerChannel) ->
            let
                cmd =
                    Cmd.map Game.Messages.MsgServers
                        (LogIndex.request "10::A8B0:207F:883E:B49F:A4BC" game.meta.config)
            in
                ( model, cmd, [] )

        _ ->
            ( model, Cmd.none, [] )
