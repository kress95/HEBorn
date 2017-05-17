module Game.Account.Requests exposing (..)

import Dict
import Json.Decode exposing (Decoder, string, decodeValue, dict, list)
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
        , ResponseDecoder
        , ResponseCode(..)
        , Response(ResponseLogout, ResponseServerIndex, ResponseInvalid)
        , ResponseForLogout(..)
        )
import Requests.Update exposing (queueRequest)
import Game.Messages exposing (GameMsg(Request))
import Game.Models exposing (GameModel, ResponseType)
import Core.Messages exposing (CoreMsg)
import Core.Models exposing (CoreModel)
import Game.Account.Messages exposing (AccountMsg(..))
import Game.Account.Models exposing (Token, AccountModel)
import Result exposing (Result(..))
import Core.Dispatcher exposing (..)
import Game.Account.Messages as Account


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


type alias ServerIndex =
    { entries : List String }


decodeServerIndex : Json.Decode.Value -> ResponseCode -> Response
decodeServerIndex rawMsg code =
    let
        decoder =
            decode (\a -> { entries = a })
                |> required "entries" (list string)
    in
        rawMsg
            |> decodeValue decoder
            |> Result.andThen
                (\{ entries } ->
                    if List.length entries > 0 then
                        Ok entries
                    else
                        Err ""
                )
            |> Result.andThen (ResponseServerIndex >> Ok)
            |> Result.withDefault ResponseInvalid


requestServerIndexHandler : ResponseType
requestServerIndexHandler response model =
    case response of
        ResponseServerIndex response ->
            let
                cmd =
                    [ callAccount (Account.ServerIndex response) ]
            in
                ( model, Cmd.none, cmd )

        _ ->
            ( model, Cmd.none, [] )
