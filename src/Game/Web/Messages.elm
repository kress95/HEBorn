module Game.Web.Messages exposing (..)

import Game.Servers.Shared as Servers exposing (CId)
import Game.Meta.Types.Desktop.Apps exposing (Requester)
import Game.Meta.Types.Network as Network


{-| Mensagens:

  - `Login` (dispatch)

Realiza login em servidor. Requer `CId` do servidor, `NIP` utilizado, `IP` do
servidor remoto, senha do servidor e o `Requester` do navegador utilizado

  - `JoinedServer` (event)

Recebida quando a conexão com o servidor falha.

  - `HandleJoinServerFailed` (dispatch)

Recebida quando a conexão com o servidor falha.

-}
type Msg
    = Login Servers.CId Network.NIP Network.IP String Requester
    | JoinedServer Servers.CId
    | HandleJoinServerFailed Servers.CId
