module TestUtils exposing (..)

import Test exposing (..)
import Config


once param =
    fuzzWith { runs = 1 } param


fuzz param =
    fuzzWith { runs = Config.baseFuzzRuns } param


ensureDifferentSeed : ( Int, Int ) -> ( Int, Int )
ensureDifferentSeed seed =
    let
        ( seed1, seed2 ) =
            seed

        seed_ =
            if seed1 == seed2 then
                ( seed1, seed1 + seed2 + 1 )
            else if seed1 == (seed2 * (-1)) then
                -- On (x, -x) seeds we've been having trouble because of our
                -- Gen.Utils generators
                ( seed1, seed2 + 1 )
            else
                seed
    in
        seed_


{-| Checks if a list is subset of another list, this function has a high
complexity, avoid using it on big collections.

There's no better way for doing that without implementing a custom set type
that accepts more types than comparables.

-}
isSubset : List a -> List a -> Bool
isSubset template list =
    let
        reducer =
            \item bool ->
                if bool then
                    List.member item template
                else
                    bool
    in
        List.foldl reducer True list
