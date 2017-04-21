module Game.Account.Messages exposing (AccountMsg(..))

import Requests.Models
    exposing
        ( ResponseLoginPayload
        , ResponseBootstrapPayload
        )
import Game.Account.Models exposing (AccountID)


type AccountMsg
    = Login ResponseLoginPayload
    | Bootstrap ResponseBootstrapPayload
    | JoinedAccount AccountID
    | Logout
