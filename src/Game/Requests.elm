module Game.Requests exposing (responseHandler)

import Requests.Models
    exposing
        ( Request
            ( NewRequest
            , RequestLogout
            , RequestServerIndex
            )
        , Response
        )
import Game.Models exposing (ResponseType)
import Game.Account.Requests exposing (requestLogoutHandler, requestServerIndexHandler)


-- Top-level response handler


responseHandler : Request -> ResponseType
responseHandler request data model =
    case request of
        RequestLogout ->
            requestLogoutHandler data model

        RequestServerIndex ->
            requestServerIndexHandler data model

        _ ->
            ( model, Cmd.none, [] )
