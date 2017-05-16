module Driver.Websocket
    exposing
        ( Model
        , Msg
        , empty
        , join
        , leave
        , update
        , subscriptions
        )

import Maybe
import Dict exposing (Dict)
import Set exposing (Set)
import Phoenix
import Phoenix.Socket as Socket exposing (Socket)
import Phoenix.Channel as Channel exposing (Channel)
import Json.Decode exposing (Value)


-- model


type alias WebsocketChannel =
    String


type alias WebsocketUrl =
    String


type alias Model =
    Dict WebsocketUrl (Set WebsocketChannel)


type Msg
    = WsJoined Value
    | WsNotification Value


empty : Model
empty =
    Dict.empty


join : WebsocketUrl -> List WebsocketChannel -> Model -> Model
join url channels model =
    channels
        |> List.foldl Set.insert (getChannels url model)
        |> setChannels url model


leave : WebsocketUrl -> List WebsocketChannel -> Model -> Model
leave url channels model =
    channels
        |> List.foldl Set.remove (getChannels url model)
        |> setChannels url model



-- tea


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    model
        |> Dict.foldl foldSubscriptions []
        |> Sub.batch



-- internals


getChannels : WebsocketUrl -> Model -> Set WebsocketChannel
getChannels url model =
    model
        |> Dict.get url
        |> Maybe.withDefault Set.empty


setChannels : WebsocketUrl -> Model -> Set WebsocketChannel -> Model
setChannels url model channels =
    Dict.insert url channels model


foldSubscriptions :
    WebsocketUrl
    -> Set WebsocketChannel
    -> List (Sub Msg)
    -> List (Sub Msg)
foldSubscriptions url channels subList =
    channels
        |> convertChannels
        |> Phoenix.connect (Socket.init url)
        |> flip (::) subList


convertChannels : Set WebsocketChannel -> List (Channel Msg)
convertChannels channels =
    channels
        |> Set.toList
        |> List.map
            (Channel.init
                >> Channel.onJoin WsJoined
                >> Channel.on "notification" WsNotification
                >> Channel.withDebug
            )
