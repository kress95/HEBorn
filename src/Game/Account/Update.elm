module Game.Account.Update exposing (..)

import Maybe
import Core.Dispatch as Dispatch exposing (Dispatch)
import Core.Messages as Core
import Driver.Websocket.Reports as Websocket
import Driver.Websocket.Channels as Websocket
import Events.Events as Events
import Game.Account.Messages exposing (..)
import Game.Account.Models exposing (..)
import Game.Account.Requests exposing (..)
import Game.Account.Requests.Logout as Logout
import Game.Account.Requests.ServerIndex as ServerIndex
import Game.Models as Game


update :
    Msg
    -> Model
    -> Game.Model
    -> ( Model, Cmd Msg, Dispatch )
update msg model game =
    case msg of
        Logout ->
            logout game model

        Request data ->
            response (receive data) game model

        Event data ->
            event data game model



-- internals


logout :
    Game.Model
    -> Model
    -> ( Model, Cmd Msg, Dispatch )
logout game model =
    let
        token =
            getToken model

        cmd =
            Logout.request token game
    in
        ( model, cmd, Dispatch.none )


response :
    Response
    -> Game.Model
    -> Model
    -> ( Model, Cmd msg, Dispatch )
response response game model =
    case response of
        _ ->
            ( model, Cmd.none, Dispatch.none )


event :
    Events.Response
    -> Game.Model
    -> Model
    -> ( Model, Cmd Msg, Dispatch )
event ev game model =
    case ev of
        Events.Report (Websocket.Joined Websocket.AccountChannel) ->
            let
                cmd =
                    ServerIndex.request (Maybe.withDefault "" model.id) game
            in
                ( model, Cmd.none, Dispatch.none )

        _ ->
            ( model, Cmd.none, Dispatch.none )
