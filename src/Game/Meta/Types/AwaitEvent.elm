module Game.Meta.Types.AwaitEvent
    exposing
        ( AwaitEvent
        , RequestId
        , empty
        , subscribe
        , receive
        )

{-| Registra uma mensagem que deve ser emitida quando receber um evento
específico com um id de request específico.
-}

import Dict exposing (Dict)


{-| `Dict` que mapeia `RequestId` para `EventMsg`.
-}
type alias AwaitEvent msg =
    Dict RequestId (EventMsg msg)


{-| `Dict` que mapeia `EventName` para `msg`.
-}
type alias EventMsg msg =
    Dict EventName msg


{-| Nome do evento.
-}
type alias EventName =
    String


{-| Id do request.
-}
type alias RequestId =
    String


{-| Registro de mensagens vazio.
-}
empty : AwaitEvent msg
empty =
    Dict.empty


{-| Registra uma mensagem que deve ser emitida ao receber um evento de tal nome
contendo tal `RequestId`.
-}
subscribe :
    RequestId
    -> ( EventName, msg )
    -> AwaitEvent msg
    -> AwaitEvent msg
subscribe requestId event awaitEvent =
    let
        msgs =
            Maybe.withDefault Dict.empty <| Dict.get requestId awaitEvent

        insertEffect ( eventName, effectMsg ) dict =
            dict
                |> Dict.insert eventName effectMsg
                |> flip (Dict.insert requestId) awaitEvent
    in
        insertEffect event msgs


{-| Retorna mensagem registrada para este `EventName` neste `RequestId`.
-}
receive : EventName -> RequestId -> AwaitEvent msg -> ( Maybe msg, AwaitEvent msg )
receive eventName requestId awaitEvent =
    ( Maybe.andThen (Dict.get eventName) (Dict.get requestId awaitEvent)
    , Dict.remove requestId awaitEvent
    )
