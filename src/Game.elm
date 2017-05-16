module Game exposing (Msg, Request)

import Game.Account as Account
import Game.Dispatcher as Dispatcher
import Game.Meta as Meta
import Game.Network as Network
import Game.Servers as Servers
import Utils.Core as Utils


type alias Model =
    { account : Account.Model
    , servers : Servers.Model
    , network : Network.Model
    , meta : Meta.Model
    }


type Msg
    = AccountMsg Account.Msg
    | ServersMsg Servers.Msg
    | NetworkMsg Network.Msg
    | MetaMsg Meta.Msg
    | DispatcherMsg Dispatcher.Msg


empty : Model
empty =
    { account = Account.empty
    , servers = Servers.empty
    , network = Network.empty
    , meta = Meta.empty
    }



-- tea


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AccountMsg subMsg ->
            ( model, Cmd.none )

        ServersMsg subMsg ->
            ( model, Cmd.none )

        NetworkMsg subMsg ->
            ( model, Cmd.none )

        MetaMsg subMsg ->
            ( model, Cmd.none )

        DispatcherMsg subMsg ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Utils.subscriptions model
        [ ( .account >> Account.subscriptions, AccountMsg )
        , ( .servers >> Servers.subscriptions, ServersMsg )
        , ( .network >> Network.subscriptions, NetworkMsg )
        , ( .meta >> Meta.subscriptions, MetaMsg )
        ]
