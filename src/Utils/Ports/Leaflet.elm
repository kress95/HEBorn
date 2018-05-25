port module Utils.Ports.Leaflet
    exposing
        ( Id
        , Latitude
        , Longitude
        , Coordinates
        , Zoom
        , Msg(..)
        , init
        , center
        , subscribe
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode, required)
import Utils.Json.Decode exposing (commonError)


{-| Map Id.
-}
type alias Id =
    String


{-| Projection point name.
-}
type alias Name =
    String


{-| Latitude coordinate.
-}
type alias Latitude =
    Float


{-| Longitude coordinate.
-}
type alias Longitude =
    Float


{-| Map coordinates.
-}
type alias Coordinates =
    { lat : Latitude
    , lng : Longitude
    }


{-| 2D Point in the map.
-}
type alias Point =
    { x : Float
    , y : Float
    }


{-| Map zoom level.
-}
type alias Zoom =
    Float


{-| Messages received from Leaflet.
-}
type Msg
    = Clicked Coordinates
    | Moved Point
    | Projected Name Point
    | Unknown


type LeafletCmd
    = Init
    | Center Coordinates Zoom


{-| Initializes Leaflet map.
-}
init : Id -> Cmd msg
init id =
    Init
        |> cmd id
        |> leafletCmd


{-| Centers given Leaflet map.
-}
center : Id -> Coordinates -> Zoom -> Cmd msg
center id coordinates zoom =
    zoom
        |> Center coordinates
        |> cmd id
        |> leafletCmd


{-| Subscribes to Leaflet.
-}
subscribe : (Id -> Msg -> msg) -> Sub msg
subscribe toMsg =
    leafletSub <|
        \value ->
            case Decode.decodeValue sub value of
                Ok ( id, sub ) ->
                    toMsg id sub

                Err msg ->
                    let
                        _ =
                            Debug.log "Leaflet communication error" msg
                    in
                        toMsg "" Unknown



-- internals


port leafletSub : (Decode.Value -> msg) -> Sub msg


port leafletCmd : Encode.Value -> Cmd msg


cmd : Id -> LeafletCmd -> Encode.Value
cmd id leafCmd =
    case leafCmd of
        Init ->
            Encode.object
                [ ( "id", Encode.string id )
                , ( "msg", Encode.string "init" )
                ]

        Center { lat, lng } zoom ->
            Encode.object
                [ ( "id", Encode.string id )
                , ( "msg", Encode.string "center" )
                , ( "lat", Encode.float lat )
                , ( "lng", Encode.float lng )
                , ( "zoom", Encode.float zoom )
                ]


sub : Decoder ( Id, Msg )
sub =
    Decode.string
        |> Decode.field "msg"
        |> Decode.andThen
            (\t ->
                case t of
                    "clicked" ->
                        decode Coordinates
                            |> required "lat" Decode.float
                            |> required "lng" Decode.float
                            |> Decode.map Clicked
                            |> Decode.map (flip (,))
                            |> required "id" Decode.string

                    "moved" ->
                        decode Point
                            |> required "x" Decode.float
                            |> required "y" Decode.float
                            |> Decode.map Moved
                            |> Decode.map (flip (,))
                            |> required "id" Decode.string

                    "projected" ->
                        decode Point
                            |> required "x" Decode.float
                            |> required "y" Decode.float
                            |> Decode.map (flip Projected)
                            |> required "name" Decode.string
                            |> Decode.map (flip (,))
                            |> required "id" Decode.string

                    _ ->
                        Decode.fail <| commonError "msg" t
            )
