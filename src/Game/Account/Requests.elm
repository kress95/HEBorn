module Game.Account.Requests exposing (..)

import Json.Decode exposing (Decoder, string, decodeValue, dict)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Requests.Models
    exposing
        ( createRequestData
        , RequestPayloadArgs
            ( RequestLogoutPayload
            , RequestEmptyPayload
            )
        , Request
            ( NewRequest
            , RequestLogout
            , RequestServer
            )
        , RequestTopic
            ( TopicAccountLogout
            , TopicAccountServer
            )
        , TopicContext
        , ResponseDecoder
        , ResponseCode(..)
        , Response
            ( ResponseLogout
            , ResponseServer
            )
        , ResponseForLogout(..)
        , ResponseForServer(..)
        , ResponseServerPayload
        )
import Requests.Update exposing (queueRequest)
import Game.Messages exposing (GameMsg(Request))
import Game.Models exposing (GameModel, ResponseType)
import Game.Account.Models exposing (Token)


requestServer : TopicContext -> Cmd GameMsg
requestServer accountID =
    queueRequest
        (Request
            (NewRequest
                (createRequestData
                    RequestServer
                    decodeServer
                    TopicAccountServer
                    accountID
                    (RequestEmptyPayload)
                )
            )
        )


decodeServer : ResponseDecoder
decodeServer rawMsg code =
    let
        decoder =
            decode ResponseServerPayload
                |> required "server_id" string
    in
        case code of
            ResponseCodeOk ->
                case decodeValue decoder rawMsg of
                    Ok msg ->
                        ResponseServer (ResponseServerOk msg)

                    Err r ->
                        ResponseServer (ResponseServerInvalid)

            _ ->
                ResponseServer (ResponseServerInvalid)


requestServerHandler : ResponseType
requestServerHandler response model =
    case response of
        _ ->
            ( model, Cmd.none, [] )


requestLogout : TopicContext -> Token -> Cmd GameMsg
requestLogout accountId token =
    queueRequest
        (Request
            (NewRequest
                (createRequestData
                    RequestLogout
                    decodeLogout
                    TopicAccountLogout
                    accountId
                    (RequestLogoutPayload
                        { token = token
                        }
                    )
                )
            )
        )


decodeLogout : ResponseDecoder
decodeLogout rawMsg code =
    case code of
        _ ->
            ResponseLogout (ResponseLogoutOk)


requestLogoutHandler : ResponseType
requestLogoutHandler response model =
    case response of
        _ ->
            ( model, Cmd.none, [] )
