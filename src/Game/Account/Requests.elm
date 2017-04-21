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
            , RequestBootstrap
            )
        , RequestTopic
            ( TopicAccountLogout
            , TopicAccountBootstrap
            )
        , TopicContext
        , ResponseDecoder
        , ResponseCode(..)
        , Response
            ( ResponseLogout
            , ResponseBootstrap
            )
        , ResponseForLogout(..)
        , ResponseForBootstrap(..)
        , ResponseBootstrapPayload
        )
import Requests.Update exposing (queueRequest)
import Game.Messages exposing (GameMsg(Request))
import Game.Models exposing (GameModel, ResponseType)
import Game.Account.Models exposing (Token)


requestBootstrap : TopicContext -> Cmd GameMsg
requestBootstrap accountID =
    queueRequest
        (Request
            (NewRequest
                (createRequestData
                    RequestBootstrap
                    decodeBootstrap
                    TopicAccountBootstrap
                    accountID
                    (RequestEmptyPayload)
                )
            )
        )


decodeBootstrap : ResponseDecoder
decodeBootstrap rawMsg code =
    let
        decoder =
            decode ResponseBootstrapPayload
                |> required "server_id" string
    in
        case code of
            ResponseCodeOk ->
                case decodeValue decoder rawMsg of
                    Ok msg ->
                        ResponseBootstrap (ResponseBootstrapOk msg)

                    Err r ->
                        ResponseBootstrap (ResponseBootstrapInvalid)

            _ ->
                ResponseBootstrap (ResponseBootstrapInvalid)


requestBootstrapHandler : ResponseType
requestBootstrapHandler response model =
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
