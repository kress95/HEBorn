module Game.Meta.Models
    exposing
        ( Model
        , initialModel
        , getLastTick
        )

import Time exposing (Time)


{-| Esta model contém dados difíceis de encaixar em outra model, como onúmero
de jogadores online e a timestamp do último segundo.
-}
type alias Model =
    { online : Int
    , lastTick : Time
    }


{-| Model inicial.
-}
initialModel : Model
initialModel =
    { online = 0
    , lastTick = 0
    }


{-| Retorna timestamp do último segundo.
-}
getLastTick : Model -> Time
getLastTick =
    .lastTick
