module Game.Servers.Requests exposing (..)

import Json.Decode exposing (Decoder, string, decodeValue)
import Json.Decode.Pipeline exposing (decode, required, optional)


-- requestFileIndex : TopicContext -> Cmd GameMsg
-- requestFileIndex serverId =
--     queueRequest
--         (Request
--             (NewRequest
--                 (createRequestData
--                     RequestLogout
--                     decodeLogout
--                     TopicAccountLogout
--                     serverId
--                     (RequestLogoutPayload
--                         { token = token
--                         }
--                     )
--                 )
--             )
--         )
