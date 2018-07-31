module Game.Account.Bounces.Config exposing (Config)

import Core.Flags as Core
import Game.Account.Bounces.Messages exposing (..)
import Game.Account.Bounces.Shared exposing (ID)
import Game.Account.Database.Models as Database


{-| Parâmetros especiais:

    - `accountId`

`Id` da conta do usuário.

    - `database`

Model do `Database`.

    - `onReloadBounce`

Lançado quando receber um pedido para recarregar bounces.

    - `onReloadIfBounceLoaded`

Lançado após receber um evento de `Bounce` atualizado, recarrega bounces.

-}
type alias Config msg =
    { flags : Core.Flags
    , batchMsg : List msg -> msg
    , toMsg : Msg -> msg
    , accountId : String
    , database : Database.Model
    , onReloadBounce : ID -> String -> msg
    , onReloadIfBounceLoaded : ID -> msg
    }
