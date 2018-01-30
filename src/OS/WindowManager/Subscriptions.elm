module OS.WindowManager.Subscriptions exposing (subscriptions)

import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)


subscriptions : Config msg -> Model -> Sub msg
subscriptions config model =
    Sub.none
