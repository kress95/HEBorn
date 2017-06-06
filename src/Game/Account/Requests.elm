module Game.Account.Requests exposing (..)

import Requests.Code exposing (RequestCode(..))


type Request
    = LoginRequest
    | LogoutRequest


handle reqt code json =
    case reqt of
        LoginRequest ->
            handleLogin code json

        LogoutRequest ->
            handleLogout code json


handleLogin code json model =
    False


handleLogout code json model =
    False



-- import Requests.Models
--     exposing
--         ( createRequestData
--         , RequestPayloadArgs(RequestLogoutPayload)
--         , Request
--             ( NewRequest
--             , RequestLogout
--             )
--         , RequestTopic(TopicAccountLogout)
--         , TopicContext
--         , Response(ResponseLogout)
--         , ResponseDecoder
--         , ResponseForLogout(..)
--         )
-- import Requests.Update exposing (queueRequest)
-- import Game.Messages exposing (GameMsg(Request))
-- import Game.Models exposing (GameModel, ResponseType)
-- requestLogout : TopicContext -> String -> Cmd GameMsg
-- requestLogout accountId token =
--     queueRequest
--         (Request
--             (NewRequest
--                 (createRequestData
--                     RequestLogout
--                     decodeLogout
--                     TopicAccountLogout
--                     accountId
--                     (RequestLogoutPayload
--                         { token = token
--                         }
--                     )
--                 )
--             )
--         )
-- decodeLogout : ResponseDecoder
-- decodeLogout rawMsg code =
--     case code of
--         _ ->
--             ResponseLogout (ResponseLogoutOk)
-- requestLogoutHandler : ResponseType
-- requestLogoutHandler response model =
--     case response of
--         _ ->
--             ( model, Cmd.none, [] )
