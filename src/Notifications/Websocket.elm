module Notifications.Websocket exposing (getJoinSubscribers)

import Core.Messages exposing (CoreMsg(NoOp))
import Core.Dispatcher exposing (..)
import Game.Account.Messages as Account
import Game.Servers.Messages as Servers


type alias Domain =
    String


joinSubscribers : String -> List ( Domain, CoreMsg )
joinSubscribers id =
    [ ( "account", callAccount (Account.JoinedAccount id) )
    ]


getJoinSubscribers : String -> CoreMsg
getJoinSubscribers topic =
    case splitTopic topic of
        Nothing ->
            NoOp

        Just ( domain, id ) ->
            let
                match =
                    List.head
                        (List.filter
                            (\( item, msg ) -> item == domain)
                            (joinSubscribers id)
                        )

                g =
                    Debug.log ">>>>" (toString match)
            in
                case match of
                    Just ( _, msg ) ->
                        msg

                    Nothing ->
                        NoOp


splitTopic : String -> Maybe ( Domain, String )
splitTopic topic =
    case (String.split ":" topic) of
        domain :: rest ->
            let
                id =
                    String.dropLeft
                        ((String.length domain) + 1)
                        topic
            in
                Just ( domain, id )

        a ->
            let
                f =
                    Debug.log ">>><<" (toString a)
            in
                Nothing
