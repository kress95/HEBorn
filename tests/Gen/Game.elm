module Gen.Game exposing (..)

import Gen.Servers
import Fuzz exposing (Fuzzer)
import Random.Pcg as Random exposing (Generator)
import Game.Models exposing (..)
import Game.Account.Models exposing (..)
import Game.Network.Models exposing (..)
import Game.Meta.Models exposing (..)
import Gen.Utils exposing (..)


model : Fuzzer GameModel
model =
    fuzzer genModel


genModel : Generator GameModel
genModel =
    Random.map
        (\servers ->
            { account = initialAccountModel
            , servers = servers
            , network = initialNetworkModel
            , meta = initialMetaModel
            }
        )
        Gen.Servers.genModel
