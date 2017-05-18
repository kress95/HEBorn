module Main exposing (..)

import Json.Decode exposing (Decoder, string, decodeValue, dict, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Requests.Models
    exposing
        ( RequestPayloadArgs(RequestEmptyPayload)
        , Request
            ( NewRequest
            , RequestProcessIndex
            )
        , RequestTopic(TopicServersProcessIndex)
        , TopicContext
        , ResponseDecoder
        , ResponseCode(..)
        , Response
            ( ResponseServersProcessIndex
            , ResponseServersProcessIndexInvalid
            )
        )
import Requests.Update exposing (queueRequest)


type alias OwnedProcess =
    { targetServerIP : String
    , targetServerID : String
    , state : String
    , softwareVersion : String
    , processType : String
    , processID : String
    , priority : Int
    , networkID : String
    , gatewayID : String
    , connectionID : Maybe String
    , allocated :
        { ulk : Int
        , ram : Int
        , dlk : Int
        , cpu : Int
        }
    }


type alias AffectingProcess =
    { targetServerID : String
    , processType : String
    , processID : String
    , networkID : String
    , gatewayID : String
    , connectionID : Maybe String
    }


type alias Allocated =
    { ulk : Int
    , ram : Int
    , dlk : Int
    , cpu : Int
    }


type alias Log =
    { ownedProcesses : OwnedProcess
    , affectingProcesses : AffectingProcess
    }


decodeServerLogIndex rawMsg code =
    let
        allocatedDecoder =
            decode Allocated
                |> required "ulk" string
                |> required "ram" string
                |> required "dlk" string
                |> required "cpu" string

        ownedDecoder =
            decode OwnedProcess
                |> required "target_server_ip" string
                |> required "target_server_id" string
                |> required "state" string
                |> required "software_version" string
                |> required "process_type" string
                |> required "process_id" string
                |> required "priority" string
                |> required "network_id" string
                |> required "gateway_id" string
                |> required "connection_id" string
                |> required "allocated" allocatedDecoder

        logDecoder =
            decoder Log
                |> required "owned_processes" ownedDecoder
                |> required "affecting_processes" affectingProcesses
    in
        rawMsg
            |> decoderValue logDecoder
            |> Result.andThen (ResponseServerLogIndex >> Ok)
            |> Result.withDefault (ResponseServerLogIndexInvalid)
