module Game.Meta.Messages exposing (Msg(..))

import Time exposing (Time)


{-| Mensagens:

  - `Tick`

    Recebida a cada segundo junto de uma timestamp.

-}
type Msg
    = Tick Time
