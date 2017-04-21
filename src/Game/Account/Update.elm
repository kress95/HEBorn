module Game.Account.Update exposing (..)

import Utils
import Driver.Websocket.Messages exposing (Msg(UpdateSocketParams, JoinChannel))
import Core.Dispatcher exposing (callAccount, callWebsocket)
import Core.Messages exposing (CoreMsg)
import Game.Models exposing (GameModel)
import Game.Messages exposing (GameMsg)
import Game.Account.Messages exposing (AccountMsg(..))
import Game.Account.Models exposing (setToken, getToken, AccountModel)
import Game.Account.Requests exposing (requestLogout)


update : AccountMsg -> AccountModel -> GameModel -> ( AccountModel, Cmd GameMsg, List CoreMsg )
update msg model game =
    case msg of
        Login data ->
            let
                { token, account_id } =
                    data

                model_ =
                    setToken model (Just token)

                coreCmd =
                    [ callWebsocket
                        (UpdateSocketParams ( token, account_id ))
                    , callWebsocket
                        (JoinChannel ("account:" ++ account_id))
                    , callWebsocket (JoinChannel ("requests"))
                    ]
            in
                ( { model_ | id = Just account_id }, Cmd.none, coreCmd )

        JoinedAccount _ ->
            ( model, Cmd.none, [] )

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
