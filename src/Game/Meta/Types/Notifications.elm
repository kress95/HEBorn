module Game.Meta.Types.Notifications exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)


{-| `Dict` com notificações.
-}
type alias Notifications a =
    Dict Id (Notification a)


{-| Identificador da notificação.
-}
type alias Id =
    ( Time, Int )


{-| Notificações contém
-}
type alias Notification a =
    { content : a
    , isRead : Bool
    }


{-| Retorna
-}
empty : Notifications a
empty =
    Dict.empty


isEmpty : Notifications a -> Bool
isEmpty =
    Dict.isEmpty


{-| Insere notificação.
-}
get : Id -> Notifications a -> Maybe (Notification a)
get id =
    Dict.get id


{-| Insere notificação.
-}
insert : Time -> Notification a -> Notifications a -> Notifications a
insert created value notifications =
    Dict.insert
        (findId ( created, 0 ) notifications)
        value
        notifications


{-| Filtra notificações não lidas.
-}
filterUnreaded : Notifications a -> Notifications a
filterUnreaded =
    Dict.filter (\_ -> .isRead >> not)


{-| Conta notificações não lidas.
-}
countUnreaded : Notifications a -> Int
countUnreaded =
    let
        counter k v a =
            if (not v.isRead) then
                a + 1
            else
                a
    in
        Dict.foldl counter 0


{-| Retorna um novo `Id` para notificações.
-}
findId : ( Time, Int ) -> Notifications a -> Id
findId (( birth, from ) as pig) notifications =
    -- caso já exista uma notificação nesta timestamp, incremente o número
    -- da direita (recursivamente até encontrar um id não utilizado)
    notifications
        |> Dict.get pig
        |> Maybe.map (\twin -> findId ( birth, from + 1 ) notifications)
        |> Maybe.withDefault pig


{-| Marca notificação como lida.
-}
markRead : Bool -> Id -> Notifications a -> Notifications a
markRead value_ id notifications =
    notifications
        |> get id
        |> Maybe.map
            -- marca notificação como lida e atualiza `Notifications`
            ((\n -> { n | isRead = value_ })
                >> (flip (Dict.insert id) notifications)
            )
        |> Maybe.withDefault notifications


{-| Marca todas as notificações como lidas.
-}
readAll : Notifications a -> Notifications a
readAll =
    Dict.map (\k v -> { v | isRead = True })


{-| Cria uma notificação nova.
-}
create : a -> Notification a
create content =
    { content = content
    , isRead = False
    }
