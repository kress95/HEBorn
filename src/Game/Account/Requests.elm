module Game.Account.Requests exposing (..)

import Json.Decode exposing (Decoder, string, decodeString, dict)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Requests.Models
    exposing
        ( createRequestData
        , RequestPayloadArgs(RequestLogoutPayload, RequestEmptyPayload)
        , Request
            ( NewRequest
            , RequestLogout
            , RequestServerIndex
            )
        , RequestTopic(TopicAccountLogout, TopicAccountServerIndex)
        , TopicContext
        , Response(ResponseLogout)
        , ResponseDecoder
        , ResponseForLogout(..)
        )
import Requests.Update exposing (queueRequest)
import Game.Messages exposing (GameMsg(Request))
import Game.Models exposing (GameModel, ResponseType)


requestLogout : TopicContext -> String -> Cmd GameMsg
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


requestServerIndex : TopicContext -> Cmd GameMsg
requestServerIndex accountID =
    queueRequest
        (Request
            (NewRequest
                (createRequestData
                    RequestServerIndex
                    decodeServerIndex
                    TopicAccountServerIndex
                    accountID
                    RequestEmptyPayload
                )
            )
        )


decodeServerIndex : ResponseDecoder
decodeServerIndex rawMsg code =
    -- Json.Encode.Value -> ResponseCode -> Response
    -- TODO: add proper a decoder
    case code of
        _ ->
            ResponseLogout (ResponseLogoutOk)
