module Game.Account.Messages exposing (AccountMsg(..))

import Json.Decode exposing (Value)
import Game.Account.Requests exposing (Requests)


type alias LoginParams =
    { token : String
    , accountID : String
    }


type AccountMsg
    = Login LoginParams
    | Logout
    | Request Requests Value
