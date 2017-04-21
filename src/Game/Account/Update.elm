module Game.Account.Update exposing (..)

import Utils
import Driver.Websocket.Messages exposing (Msg(UpdateSocketParams, JoinChannel))
import Core.Messages exposing (CoreMsg(MsgWebsocket))
import Game.Models exposing (GameModel)
import Game.Messages exposing (GameMsg)
import Game.Account.Messages exposing (AccountMsg(..))
import Game.Account.Models exposing (setToken, getToken, AccountModel)
import Game.Account.Requests exposing (requestLogout, requestBootstrap)


update : AccountMsg -> AccountModel -> GameModel -> ( AccountModel, Cmd GameMsg, List CoreMsg )
update msg model game =
    case msg of
        Login data ->
            let
                { token, account_id } =
                    data

                model_ =
                    setToken model (Just token)

                cmd =
                    requestBootstrap account_id

                coreCmd =
                    [ MsgWebsocket
                        (UpdateSocketParams ( token, account_id ))
                    , MsgWebsocket
                        (JoinChannel ( "account:" ++ account_id, "notification" ))
                    , MsgWebsocket
                        (JoinChannel ( "requests", "requests" ))
                    ]
            in
                ( { model_ | id = Just account_id }, cmd, coreCmd )

        Logout ->
            let
                cmd =
                    requestLogout
                        (Utils.maybeToString model.id)
                        (Utils.maybeToString (getToken model))

                model_ =
                    setToken model Nothing
            in
                ( model_, cmd, [] )

        Bootstrap data ->
            let
                f =
                    Debug.log "RFECV" (toString data)
            in
                ( model, Cmd.none, [] )
