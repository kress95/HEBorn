module Game.Servers.Logs.Requests exposing (..)

import Dict
import Json.Decode exposing (Decoder, string, decodeValue, dict, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Requests.Models
    exposing
        ( RequestPayloadArgs(RequestEmptyPayload)
        , Request
            ( NewRequest
            , RequestLogIndex
            )
        , RequestTopic(TopicServersLogIndex)
        , TopicContext
        , ResponseDecoder
        , ResponseCode(..)
        , Response(ResponseServersLogIndex, ResponseServersLogIndexInvalid)
        )
import Requests.Update exposing (queueRequest)


requestLogIndex serverID =
    queueRequest
        (Request
            (NewRequest
                (createRequestData
                    RequestServersLogIndex
                    decodeServerLogIndex
                    TopicServersLogIndex
                    serverID
                    RequestEmptyPayload
                )
            )
        )


type alias Log =
    { logID : String, messages : String, timestamp : String }


type alias Logs =
    List Log


decodeServerLogIndex rawMsg code =
    let
        logDecoder =
            decode Log
                |> required "log_id" string
                |> required "message" string
                |> required "inserted_at" string

        ownedDecoder =
            required "entries" (list logDecoder) (decode Logs)
    in
        rawMsg
            |> decoderValue logDecoder
            |> Result.andThen (ResponseServerLogIndex >> Ok)
            |> Result.withDefault (ResponseServerLogIndexInvalid)


requestLogIndexRequestHandler response model =
    case response of
        ResponseServersLogIndex msg ->
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
