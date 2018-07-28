module Game.Inventory.Messages exposing (Msg(..))

import Game.Inventory.Shared exposing (..)


{-| Mensagens:

  - `HandleComponentUsed` (dispatch)

Marca um componente como utilizado. Requer `Entry` do componente.

  - `HandleComponentFreed` (dispatch)

Marca um componente como livre. Requer `Entry` do componente.

-}
type Msg
    = HandleComponentUsed Entry
    | HandleComponentFreed Entry
