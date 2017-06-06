module Game.Account.Messages exposing (AccountMsg(..))

import Game.Account.Models exposing (AccountID)


type AccountMsg
    = Login 
    | Logout
