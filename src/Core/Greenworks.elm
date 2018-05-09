port module Core.Greenworks exposing (Notification(..), subscribe, getNumberOfPlayers)

{-| Binds Elm with the excelent Greenworks library, providing integration
with Steam, the binding gracefully fallbacks to noops given that steam is not
available.


# Connectivity

@docs connection, shutdown, oneOf


# Archievements

@docs andThen

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode)
import Utils.Json.Decode exposing (commonError)


-- interesting features: fetch


{-| Data received from Greenworks
-}
type Notification
    = Greenworks (Maybe Bool)
    | CloudEnabled Bool
    | CloudEnabledForUser Bool
    | Connected
    | Disconnected
    | ConnectFailure
    | Shutdown
    | NumberOfPlayers (Result String Int)
    | Unknown


{-| Data sent to Greenworks.
-}
type Action
    = GetNumberOfPlayers


getNumberOfPlayers : Cmd msg
getNumberOfPlayers =
    GetNumberOfPlayers
        |> action
        |> toGreenworks


subscribe : (Notification -> msg) -> Sub msg
subscribe toMsg =
    fromGreenworks (decodeNotification >> toMsg)



-- internals


{-| Used to receive data from Greenworks.
-}
port fromGreenworks : (Decode.Value -> msg) -> Sub msg


{-| Used to send data tp Greenworks.
-}
port toGreenworks : Encode.Value -> Cmd msg


{-| Encode actions.
-}
action : Action -> Encode.Value
action notif =
    case notif of
        GetNumberOfPlayers ->
            Encode.object
                [ ( "action", Encode.string "getNumberOfPlayers" )
                ]


{-| Decode notifications.
-}
notification : Decoder Notification
notification =
    let
        greenworks =
            Decode.bool
                |> Decode.field "value"
                |> Decode.maybe
                |> Decode.map Greenworks

        cloudEnabled =
            Decode.bool
                |> Decode.field "value"
                |> Decode.map CloudEnabled

        cloudEnabledForUser =
            Decode.bool
                |> Decode.field "value"
                |> Decode.map CloudEnabledForUser

        numberOfPlayers =
            [ Decode.int
                |> Decode.field "value"
                |> Decode.map Ok
            , Decode.string
                |> Decode.field "value"
                |> Decode.map Err
            ]
                |> Decode.oneOf
                |> Decode.map NumberOfPlayers

        byType t =
            case t of
                "greenworks" ->
                    greenworks

                "isCloudEnabled" ->
                    cloudEnabled

                "isCloudEnabledForUser" ->
                    cloudEnabledForUser

                "connected" ->
                    Decode.succeed Connected

                "disconnected" ->
                    Decode.succeed Disconnected

                "connectFailure" ->
                    Decode.succeed ConnectFailure

                "shutdown" ->
                    Decode.succeed Shutdown

                "numberOfPlayers" ->
                    numberOfPlayers

                _ ->
                    Decode.fail <| commonError "message" t

        typeField =
            Decode.field "message" Decode.string
    in
        Decode.andThen byType typeField


decodeNotification : Decode.Value -> Notification
decodeNotification value =
    case Decode.decodeValue notification value of
        Ok notif ->
            notif

        Err msg ->
            let
                _ =
                    Debug.log "Greenworks communication error" msg
            in
                Unknown
