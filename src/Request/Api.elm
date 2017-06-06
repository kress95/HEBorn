module Request.Api
    exposing
        ( Msg(..)
        , RequestType(..)
        , requestHandler
        )

import Game.Messages exposing (GameMsg)
import Json.Decode exposing (Value)
import Game.Account.Request as Account


requestHandler : RequestType -> Value -> GameMsg
requestHandler t json =
    case t of
        LoginRequest ->
            Account.loginHandler json

        LogoutRequest ->
            Account.loginHandler json


test : String
test = False