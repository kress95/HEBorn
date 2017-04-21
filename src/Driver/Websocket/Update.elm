module Driver.Websocket.Update exposing (update)

import Json.Encode
import Json.Decode exposing (decodeString, string, decodeValue)
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel
import Utils
import Driver.Websocket.Models
    exposing
        ( Model
        , getWSMsgType
        , getWSMsgMeta
        , WSMsgType(..)
        , getResponse
        )
import Driver.Websocket.Messages exposing (Msg(..))
import Events.Models exposing (decodeEvent)
import Core.Messages exposing (CoreMsg(NoOp, DispatchEvent, NewResponse))
import Core.Models exposing (CoreModel)
import Notifications.Websocket as Notifications


update : Msg -> Model -> CoreModel -> ( Model, Cmd Msg, List CoreMsg )
update msg model core =
    case msg of
        UpdateSocketParams params ->
            let
                ( token, account_id ) =
                    params

                socket_ =
                    model.socket
                        |> Socket.withParams [ ( "token", token ) ]
            in
                ( { model | socket = socket_ }, Cmd.none, [] )

        Joined topic ->
            let
                domain =
                    case (decodeValue string topic) of
                        Ok s ->
                            s

                        Err _ ->
                            ""

                subscriberNotification =
                    Notifications.getJoinSubscribers domain
            in
                ( model, Cmd.none, [ subscriberNotification ] )

        JoinChannel topic ->
            let
                ( model_, cmd ) =
                    if model.defer then
                        ( { model | defer = False }
                        , Utils.delay 0.5 <| JoinChannel topic
                        )
                    else
                        let
                            channel =
                                Channel.init topic
                                    |> Channel.onJoin (\_ -> Joined (Json.Encode.string topic))
                                    |> Channel.on "notification" (\m -> NewNotification m)
                                    |> Channel.withDebug

                            channels_ =
                                model.channels ++ [ channel ]
                        in
                            ( { model | channels = channels_ }, Cmd.none )
            in
                ( model_, cmd, [] )

        NewNotification msg ->
            let
                meta =
                    getWSMsgMeta msg

                coreMsg =
                    case (getWSMsgType meta) of
                        WSEvent ->
                            let
                                event =
                                    decodeEvent msg
                            in
                                DispatchEvent event

                        WSResponse ->
                            let
                                d =
                                    Debug.log
                                        "received a reply on an event topic"
                                        (toString msg)
                            in
                                NoOp

                        WSInvalid ->
                            NoOp
            in
                ( model, Cmd.none, [ coreMsg ] )

        NewReply msg requestId ->
            let
                ( meta, code ) =
                    getResponse msg

                coreMsg =
                    NewResponse ( requestId, code, meta.data )
            in
                ( model, Cmd.none, [ coreMsg ] )
