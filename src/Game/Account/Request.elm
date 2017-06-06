module Game.Account.Request exposing (login, loginHandler)

import Request.Types exposing (RequestType(..), request)
import Game.Messages exposing (GameMsg)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode


login : String -> String -> Msg
login username password =
    let
        payload =
            Encode.object
                [ ( "username", Encode.string username )
                , ( "password", Encode.string password )
                ]
    in
        request LoginRequest payload


loginHandler : Value -> GameMsg
loginHandler json =
    Debug.crash "TODO"



-- import Json.Encode as Encode
-- import Json.Decode as Decode exposing (Value)
-- import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
-- import Requests.Update exposing (request)
-- import Json.Decode exposing (Value)
-- type Request
--     = LoginRequest
--     | LogoutRequest
-- logout : String -> String -> Cmd GameMsg
-- logout token =
--     let
--         payload =
--             Encode.object
--                 [ ( "token", Decode.string token ) ]
--     in
--         request LoginRequest payload
-- handle : Request -> Value -> String
-- handle request value =
--     case request of
--         LoginRequest ->
--             loginHandler value
--         LogoutRequest ->
--             logoutHandler value
-- -- internals
-- loginHandler value =
--     ""
-- logoutHandler value =
--     ""
