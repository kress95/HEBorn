module Requests.Types
    exposing
        ( Driver(..)
        , Code(..)
        , ResponseType
        , WebsocketResponse
        , Context
        , getCode
        , emptyPayload
        )

import Json.Decode
import Json.Encode as Encode


type alias ResponseType =
    ( Code, String )


type alias WebsocketResponse =
    { data : Json.Decode.Value }


type Driver
    = WebsocketDriver
    | HttpDriver


type Code
    = OkCode
    | NotFoundCode
    | BadRequestCode
    | UnknownErrorCode


type alias Context =
    Maybe String


getCode : Int -> Code
getCode code =
    case code of
        200 ->
            OkCode

        404 ->
            NotFoundCode

        400 ->
            BadRequestCode

        _ ->
            UnknownErrorCode


emptyPayload : Encode.Value
emptyPayload =
    -- empty payload for request
    Encode.object []
