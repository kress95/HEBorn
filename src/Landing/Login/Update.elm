module Landing.Login.Update exposing (..)

import Landing.Login.Messages exposing (Msg(..))
import Landing.Login.Models exposing (Model)
import Landing.Login.Requests exposing (..)
import Landing.Login.Requests.Login as Login
import Driver.Websocket.Channels exposing (..)
import Core.Messages as Core
import Core.Models as Core
import Core.Dispatch as Dispatch exposing (Dispatch)
import Driver.Websocket.Messages as Ws


update : Msg -> Model -> Core.HomeModel -> ( Model, Cmd Msg, Dispatch )
update msg model core =
    case msg of
        SubmitLogin ->
            let
                cmd =
                    Login.request
                        model.username
                        model.password
                        core
            in
                ( model, cmd, Dispatch.none )

        SetUsername username ->
            ( { model | username = username }, Cmd.none, Dispatch.none )

        ValidateUsername ->
            ( model, Cmd.none, Dispatch.none )

        SetPassword password ->
            ( { model | password = password }, Cmd.none, Dispatch.none )

        ValidatePassword ->
            ( model, Cmd.none, Dispatch.none )

        Request data ->
            response (receive data) model core


response :
    Response
    -> Model
    -> Core.HomeModel
    -> ( Model, Cmd Msg, Dispatch )
response response model core =
    case response of
        LoginResponse (Login.OkResponse token id) ->
            let
                model_ =
                    { model | loginFailed = False }

                msgs =
                    Dispatch.batch
                        [ Dispatch.core (Core.Bootstrap token)
                        , Dispatch.websocket
                            (Ws.JoinChannel AccountChannel (Just id))
                        , Dispatch.websocket
                            (Ws.JoinChannel RequestsChannel Nothing)
                        ]
            in
                ( model_, Cmd.none, msgs )

        LoginResponse Login.ErrorResponse ->
            let
                model_ =
                    { model | loginFailed = True }
            in
                ( model_, Cmd.none, Dispatch.none )

        _ ->
            ( model, Cmd.none, Dispatch.none )
