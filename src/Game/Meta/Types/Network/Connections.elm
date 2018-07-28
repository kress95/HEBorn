module Game.Meta.Types.Network.Connections exposing (..)

{-| Conexões de rede.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Network exposing (NIP)


{-| Id da conexão de rede é igual um `NIP`.
-}
type alias Id =
    NIP


{-| `Dict` que guarda conexões de rede.
-}
type alias Connections =
    Dict Id Connection


{-| Conexões de rede contém o nome da conexão e sua disponibilidade.
-}
type alias Connection =
    { name : String
    , available : Bool
    }


{-| Retorna um `Dict` de conexões vazio.
-}
empty : Connections
empty =
    Dict.empty


{-| Tenta pegar component do `Dict` de componentes.
-}
get : Id -> Connections -> Maybe Connection
get =
    Dict.get


{-| Verifica se uma conexão está presente no `Dict` de conexões.
-}
member : Id -> Connections -> Bool
member =
    Dict.member


{-| Insere uma conexão do `Dict` de conexões.
-}
insert : Id -> Connection -> Connections -> Connections
insert =
    Dict.insert


{-| Remove uma conexão do `Dict` de conexões.
-}
remove : Id -> Connections -> Connections
remove =
    Dict.remove


{-| Atualiza disponibilidade de uma conexão.
-}
setAvailable : Bool -> Connection -> Connection
setAvailable available connection =
    { connection | available = available }


{-| Retorna nome de uma conexão.
-}
getName : Connection -> String
getName =
    .name


{-| Retorna disponibilidade de uma conexão.
-}
isAvailable : Connection -> Bool
isAvailable =
    .available
