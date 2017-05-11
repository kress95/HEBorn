module Game.Account.Messages exposing (AccountMsg(..))

import Requests.Models
    exposing
        ( ResponseLoginPayload
        , ResponseServerPayload
        )
import Game.Account.Models exposing (AccountID)


type AccountMsg
    = Login ResponseLoginPayload
    | Server ResponseServerPayload
    | JoinedAccount AccountID
    | Logout
