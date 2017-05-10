module Gen.Utils exposing (..)

import Fuzz exposing (Fuzzer)
import Random.Pcg exposing (Generator, float)
import Random.Pcg.Char exposing (english)
import Random.Pcg.Extra exposing (rangeLengthList)
import Random.Pcg.String as RandomString exposing (rangeLengthString)
import Shrink exposing (noShrink)


unique : Generator String
unique =
    rangeLengthString 64 64 english


stringRange : Int -> Int -> Generator String
stringRange min max =
    rangeLengthString min max english


fuzzer : Generator a -> Fuzzer a
fuzzer f =
    Fuzz.custom f Shrink.noShrink


string : Int -> Generator String
string length =
    RandomString.string length english


listRange : Int -> Int -> Generator a -> Generator (List a)
listRange min max =
    rangeLengthList min max


percentage : Generator Float
percentage =
    float 0 1
