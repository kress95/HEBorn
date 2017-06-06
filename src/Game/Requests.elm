module Game.Requests exposing (handler)

import Game.Account.Requests as Account
import Game.Account.Requests exposing (requestLogoutHandler)

type Request
    = AccountRequest Account.Request
