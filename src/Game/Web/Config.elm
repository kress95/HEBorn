module Game.Web.Config exposing (..)

import Json.Decode exposing (Value)
import Core.Flags as Core
import Game.Meta.Types.Desktop.Apps exposing (Requester)
import Game.Servers.Models as Servers
import Game.Servers.Shared exposing (CId)
import Game.Web.Messages exposing (..)


{-| Parâmetros especiais:

  - `servers`

Deve conter `Servers.Model`.

  - `onLogin`

Mensagem enviada quando receber a resposta do request de login.

  - `onJoinedServer`

Mensagem enviada quando conectar com um servidor.

  - `onJoinFailed`

Mensagem enviada quando a conexão com um servidor falhar.

-}
type alias Config msg =
    { toMsg : Msg -> msg
    , batchMsg : List msg -> msg
    , flags : Core.Flags
    , servers : Servers.Model
    , onLogin : CId -> Maybe Value -> msg
    , onJoinedServer : CId -> CId -> msg
    , onJoinFailed : Requester -> msg
    }
