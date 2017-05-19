module Game.Account.Requests exposing (..)

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
        , Response
            ( ResponseLogout
            , ResponseServersIndex
            , ResponseServersIndexInvalid
            )
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


type alias ServerItem =
    { serverID : String
    , serverType : String
    , password : String
    , hardware : Maybe String
    , ipList : List String
    }


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


decodeServerIndex : Json.Decode.Value -> ResponseCode -> Response
decodeServerIndex rawMsg code =
    let
        decoder =
            decode ServerItem
                |> required "server_id" string
                |> required "server_type" string
                |> required "password" string
                |> optional "hardware" string
                |> required "ips" (list string)
    in
        case code of
            _ ->
                rawMsg
                    |> decodeValue (list decoder)
                    |> Result.andThen (ResponseServersIndex >> Ok)
                    |> Result.withDefault ResponseServersIndexInvalid


requestServerIndexHandler : ResponseType
requestServerIndexHandler response model =
    case response of
        ResponseServersIndex msg ->
            let
                { entries } =
                    msg

                cmds =
                    if List.length entries > 0 then
                        [ callAccount (Account.ServerIndex entries) ]
                    else
                        []
            in
                ( model, Cmd.none, cmds )

        _ ->
            ( model, Cmd.none, [] )
