module Driver.Websocket.Topics
    exposing
        ( RequestTopic(..)
        , RequestChannel(..)
        , getMsg
        , getChannel
        , getAddress
        , none
        )


type RequestTopic
    = TopicAccountLogin
    | TopicAccountCreate
    | TopicAccountLogout


type RequestChannel
    = ChannelAccount
    | ChannelRequests


type alias TopicContext =
    String


none : TopicContext
none =
    ""


getMsg : RequestTopic -> String
getMsg topic =
    case topic of
        TopicAccountLogin ->
            "account.login"

        TopicAccountCreate ->
            "account.create"

        TopicAccountLogout ->
            "account.get"


getChannel : RequestTopic -> RequestChannel
getChannel topic =
    case topic of
        TopicAccountLogin ->
            ChannelAccount

        TopicAccountCreate ->
            ChannelAccount

        TopicAccountLogout ->
            ChannelRequests


getAddress : RequestChannel -> TopicContext -> String
getAddress channel context =
    case channel of
        ChannelAccount ->
            "account:" ++ context

        ChannelRequests ->
            "requests"
