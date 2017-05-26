module OS.SessionManager.Models
    exposing
        ( ServerID
        , EndpointID
        , RemoteSessions
        , Server
        , Servers
        , WindowRef
        , Model
        , initialModel
        , switchServer
        , connect
        , disconnect
        , removeServer
        , removeEndpoint
        , getWindowManager
        , setWindowManager
        , getWindows
        , setWindows
        , getWindow
        )

import Dict exposing (Dict)
import OS.SessionManager.WindowManager.Models as WindowManager
    exposing
        ( WindowID
        , Window
        , setWindow
        )


type alias ServerID =
    String


type alias EndpointID =
    String


type alias RemoteSessions =
    Dict EndpointID WindowManager.Model


type alias Server =
    { endpoint : Maybe EndpointID
    , localhost : WindowManager.Model
    , sessions : RemoteSessions
    }


type alias Servers =
    Dict ServerID Server



-- EVAL: a window id may have to be generated here or elsewhere if we
-- want their ids to be globally unique


type WindowRef
    = WindowRef ServerID (Maybe EndpointID) WindowID


type alias Model =
    -- the serverID state should be managed by game model
    { server : ServerID
    , servers : Servers

    -- add this to support pinned windows:
    -- , drawOrder : List WindowRef
    }


initialModel : Model
initialModel =
    { server = "login"
    , servers = Dict.empty

    -- , drawOrder = []
    }


switchServer : ServerID -> Model -> Model
switchServer serverID ({ servers } as model) =
    -- this function should be removed after moving the
    -- active server to game
    case Dict.get serverID servers of
        Just _ ->
            { model | server = serverID }

        Nothing ->
            -- never change to undefined servers
            model


connect : EndpointID -> Model -> Model
connect endpoint ({ server, servers } as model) =
    liftServer (\server -> { server | endpoint = Just endpoint }) model


disconnect : Model -> Model
disconnect model =
    liftServer (\server -> { server | endpoint = Nothing }) model


removeServer : ServerID -> Model -> Model
removeServer server ({ servers } as model) =
    { model | servers = Dict.remove server model.servers }


removeEndpoint : EndpointID -> Model -> Model
removeEndpoint endpoint =
    liftServer
        (\({ sessions } as server) ->
            { server | sessions = Dict.remove endpoint sessions }
        )


getWindowManager : Model -> Maybe WindowManager.Model
getWindowManager ({ server, servers } as model) =
    servers
        |> Dict.get server
        |> Maybe.andThen getServerWM


setWindowManager : WindowManager.Model -> Model -> Model
setWindowManager wm model =
    liftWM (always wm) model


getWindows : Model -> WindowManager.Windows
getWindows model =
    model
        |> getWindowManager
        |> Maybe.map (.windows)
        |> Maybe.withDefault Dict.empty


setWindows : WindowManager.Windows -> Model -> Model
setWindows windows ({ servers } as model) =
    case Dict.get model.server servers of
        Just server ->
            model
                |> getWindowManager
                |> Maybe.map
                    (\wm ->
                        let
                            wm_ =
                                { wm | windows = windows }

                            server_ =
                                setServerWM wm_ server

                            servers_ =
                                Dict.insert model.server server_ model.servers
                        in
                            { model | servers = servers_ }
                    )
                |> Maybe.withDefault model

        Nothing ->
            model



-- TODO: evaluate if this is needed


getWindow : WindowRef -> Model -> Maybe Window
getWindow ref model =
    case ref of
        WindowRef serverID endpoint windowID ->
            model
                |> getWindowManager
                |> Maybe.andThen (WindowManager.getWindow windowID)



-- internals


liftServer : (Server -> Server) -> Model -> Model
liftServer fun ({ servers, server } as model) =
    let
        servers_ =
            servers
                |> Dict.get server
                |> Maybe.map
                    (\server_ ->
                        Dict.insert
                            server
                            (fun server_)
                            servers
                    )
                |> Maybe.withDefault servers
    in
        { model | servers = servers_ }


liftWM : (WindowManager.Model -> WindowManager.Model) -> Model -> Model
liftWM fun =
    liftServer
        (\({ endpoint, localhost, sessions } as server) ->
            case endpoint of
                Just id ->
                    let
                        sessions_ =
                            sessions
                                |> Dict.get id
                                |> Maybe.map fun
                                |> Maybe.map (flip (Dict.insert id) sessions)
                                |> Maybe.withDefault sessions
                    in
                        { server | sessions = sessions_ }

                Nothing ->
                    { server | localhost = fun localhost }
        )


getServerWM : Server -> Maybe WindowManager.Model
getServerWM { endpoint, sessions, localhost } =
    case endpoint of
        Just endpointID ->
            Dict.get endpointID sessions

        Nothing ->
            Just localhost


setServerWM : WindowManager.Model -> Server -> Server
setServerWM wm ({ endpoint, sessions, localhost } as server) =
    case endpoint of
        Just endpointID ->
            { server | sessions = Dict.insert endpointID wm sessions }

        Nothing ->
            { server | localhost = wm }
