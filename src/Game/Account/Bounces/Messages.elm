module Game.Account.Bounces.Messages exposing (..)

import Game.Account.Bounces.Models exposing (Bounce)
import Game.Account.Bounces.Shared exposing (ID)
import Game.Meta.Types.Desktop.Apps exposing (Reference)


{-| Mensagens:

  - `HandleCreated` (evento)

Recebido quando um `Bounce` é criado.

  - `HandleUpdated` (evento)

Recebido quando um `Bounce` é atualizado.

  - `HandleRemoved` (evento)

Recebido quando um `Bounce` é removido.

  - `HandleWaitForBounce` (dispatch)

Adiciona uma `Bounce` otimista. Requer `String` e `Reference`.

  - `HandleRequestReload` (dispatch)

Envia pedido para recarregar janelas do `BounceManager`. Requer `ID` e
`Reference`.

-}
type Msg
    = HandleCreated String ID Bounce
    | HandleUpdated ID Bounce
    | HandleRemoved ID
    | HandleWaitForBounce String Reference
    | HandleRequestReload ID Reference
