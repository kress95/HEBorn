module Requests.Models exposing (..)


import Json.Decode as Decode exposing (Value, value)
import Json.Decode.Pipeline exposing (required)


type ResponseCode
    = ResponseCodeOk
    | ResponseCodeNotFound
    | ResponseCodeUnknownError


type RequestDriver
    = DriverWebsocket
    | DriverHTTP

type alias Topic =
    String


type alias TopicContext =
    String


type alias ChannelAddress =
    String
    

type alias AddressGetter =
    (TopicContext -> ChannelAddress)


type alias Channel a =
    { name : a, address : AddressGetter}


type alias TopicRequest a =
    { topic : Topic, channel : Channel a }


type alias RequestID =
    String


type alias PartialResponse =
    {data : Decode.Value}


type alias ResponseDecoder a =
    ResponseCode -> Value -> a


getTopic : TopicRequest a -> Topic
getTopic req =
    req.topic


getChannel : TopicRequest a -> Channel a
getChannel req =
    req.channel


getChannelAddress : Channel a -> AddressGetter
getChannelAddress channel =
    channel.address


getChannelName : Channel a -> a
getChannelName  channel =
    channel.name


getAddress : TopicRequest a -> AddressGetter
getAddress req =
    req
    |> getChannel
    |> getChannelAddress


getName : TopicRequest a -> a
getName req =
    req
    |> getChannel
    |> getChannelName

decodeDataValue : Decode.Decoder (Value -> b) -> Decode.Decoder b
decodeDataValue =
    required "data" value