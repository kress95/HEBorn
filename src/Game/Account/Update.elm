module Game.Account.Update exposing (..)

import Maybe
import Core.Messages exposing (CoreMsg(MsgWebsocket))
import Game.Account.Messages exposing (..)
import Game.Account.Models exposing (..)
import Game.Account.Requests exposing (..)
import Game.Account.Requests.Logout as Logout
import Game.Models exposing (GameModel)


update :
    AccountMsg
    -> AccountModel
    -> GameModel
    -> ( AccountModel, Cmd AccountMsg, List CoreMsg )
update msg model game =
    case msg of
        Login token id ->
            login token id model game

        Logout ->
            logout model game

        Request data ->
            response (receive data) model game

        _ ->
            ( model, Cmd.none, [] )



-- internals


response :
    Response
    -> AccountModel
    -> GameModel
    -> ( AccountModel, Cmd msg, List CoreMsg )
response response model game =
    case response of
        LogoutResponse Logout.OkResponse ->
            ( model, Cmd.none, [] )

        _ ->
            ( model, Cmd.none, [] )


login :
    Token
    -> String
    -> AccountModel
    -> GameModel
    -> ( AccountModel, Cmd AccountMsg, List CoreMsg )
login token id model game =
    let
        model1 =
            setToken model (Just token)

        model_ =
            { model1 | id = Just id }
    in
        ( model_, Cmd.none, [] )


logout :
    AccountModel
    -> GameModel
    -> ( AccountModel, Cmd AccountMsg, List CoreMsg )
logout model game =
    case getToken model of
        Just token ->
            let
                model_ =
                    setToken model Nothing

                cmd =
                    Logout.request token game.meta.config
            in
                ( model_, cmd, [] )

        _ ->
            ( model, Cmd.none, [] )
