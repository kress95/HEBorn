module Game.Servers.Tunnels.Models exposing (..)

import Dict exposing (Dict)
import Game.Account.Bounces.Models exposing (..)


type alias Model =
    { active : ActiveTunnel
    , outgoing : Tunnels
    , incoming : Tunnels
    }


type ActiveTunnel =
    -- this is always an outgoing tunnel
    Maybe TunnelID


type alias Tunnels =
    Dict TunnelID Tunnel


type alias TunnelID =
    String


type alias Tunnel =
    { gateway : IP
    , endpoint : IP
    , bounce : Maybe BounceID
    , connections : Connections
    }


type alias IP =
    String


type alias Connections =
    Dict ConnectionID Connection


type alias ConnectionID =
    String


type alias Connection =
    -- this may receive more data as we integrate things
    { type_ : ConnectionType }


type ConnectionType
    = ConnectionFTP
    | ConnectionSSH
    | ConnectionX11
    | ConnectionUnknown



--


type Accessor a b
    = Accessor (Getter a b) (Setter a b)


type alias Getter a b =
    b -> a


type alias Setter a b =
    a -> b -> b



--


getActive : Model -> ActiveTunnel
getActive =
    getter active


setActive : ActiveTunnel -> Model -> Model
setActive =
    setter active

insertTunnel

removeTunnel : Tunnel -> Model -> Model

updateActiveTunnel : Tunnel -> Model -> Model


--


getter : Accessor a b -> Getter a b
getter lens =
    case lens of
        Accessor getter _ ->
            getter


setter : Accessor a b -> Setter a b
setter lens =
    case lens of
        Accessor _ setter ->
            setter


active : Accessor ActiveTunnel Model
active =
    let
        get =
            .active

        set a b =
            { b | active = a }
    in
        Accessor get set


incoming : Accessor Tunnels Model
incoming =
    let
        get =
            .incoming

        set a b =
            { b | incoming = a }
    in
        Accessor get set


outgoing : Accessor Tunnels Model
outgoing =
    let
        get =
            .outgoing

        set a b =
            { b | outgoing = a }
    in
        Accessor get set
