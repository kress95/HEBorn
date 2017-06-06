module Landing.Login.Messages exposing (..)

import Json.Decode exposing (Value)
import Landing.Requests exposing (Requests)
import Requests.Code exposing (RequestCode)
import Events.Models


type Msg
    = SubmitLogin
    | SetUsername String
    | ValidateUsername
    | SetPassword String
    | ValidatePassword
    | Request Requests RequestCode Value
