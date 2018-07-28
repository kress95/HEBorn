module Game.Inventory.Shared exposing (..)

import Dict exposing (Dict)
import Game.Meta.Types.Components as Components exposing (Components)
import Game.Meta.Types.Network.Connections as Connections exposing (Connections)


{-| Tipos de entrada do inventário, pode ser um componente ou uma conexão de rede.
-}
type Entry
    = Component Components.Id
    | NetConnection Connections.Id


{-| Grupo de grupos.
-}
type alias Groups =
    Dict String Group


{-| `Entries` da esquerda estão disponíveis, da direita indisponíveis.
-}
type alias Group =
    ( Entries, Entries )


{-| Lista de entradas.
-}
type alias Entries =
    List Entry
