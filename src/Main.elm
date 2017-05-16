module Main exposing (main)

import Driver.Http as Http
import Driver.Websocket as Ws
import Utils.Core as Utils
import UrlParser exposing (Parser, parseHash, oneOf, map, top, s)
import Html exposing (Html, text)
import Navigation exposing (Location, programWithFlags)


type Placeholder
    = Placeholder


type alias Flags =
    { seed : Int
    , apiHttpUrl : String
    , apiWsUrl : String
    , version : String
    }


type alias Config =
    { apiHttpUrl : String
    , apiWsUrl : String
    , version : String
    }


type alias Model =
    { config : Config
    , route : Route
    , websocket : Ws.Model
    }


type Msg
    = HttpMsg Http.Msg
    | WsMsg Ws.Msg
    | OnLocationChange Location
    | LandMsg Placeholder
    | GameMsg Placeholder
    | OSMsg Placeholder
    | AppMsg Placeholder


type Route
    = RouteLanding
    | RouteGame
    | RouteNotFound



-- tea


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        config =
            Config
                flags.apiHttpUrl
                flags.apiWsUrl
                flags.version

        model =
            { config = config
            , route = RouteLanding
            , websocket = Ws.empty
            }
    in
        ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model.route of
        RouteLanding ->
            text "landing"

        RouteGame ->
            text "game"

        RouteNotFound ->
            text "404"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WsMsg subMsg ->
            model.websocket
                |> Ws.update subMsg
                |> Utils.update WsMsg (\a -> { model | websocket = a })

        HttpMsg subMsg ->
            -- TODO: add handler
            ( model, Cmd.none )

        OnLocationChange location ->
            ( { model | route = route location }, Cmd.none )

        LandMsg subMsg ->
            -- TODO: add handler
            ( model, Cmd.none )

        GameMsg subMsg ->
            -- TODO: add handler
            ( model, Cmd.none )

        OSMsg subMsg ->
            -- TODO: add handler
            ( model, Cmd.none )

        AppMsg subMsg ->
            -- TODO: add handler
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Utils.subscriptions model
        [ .websocket >> Ws.subscriptions >> Sub.map WsMsg
        ]


main : Program Flags Model Msg
main =
    programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- internals


route : Location -> Route
route location =
    case parseHash parse location of
        Just route ->
            route

        Nothing ->
            RouteNotFound


parse : Parser (Route -> c) c
parse =
    oneOf
        [ map RouteLanding top
        ]
