module Gen.Servers exposing (..)

import Gen.Filesystem
import Gen.Logs
import Gen.Processes
import Random.Pcg.Char as RandomChar
import Random.Pcg.String as RandomString
import Random.Pcg.Extra as RandomExtra exposing (andMap)
import Random.Pcg as Random exposing (Generator)
import Fuzz exposing (Fuzzer)
import Game.Shared exposing (IP)
import Game.Servers.Models exposing (..)
import Gen.Utils exposing (..)


--------------------------------------------------------------------------------
-- Fuzzers
--------------------------------------------------------------------------------


serverID : Fuzzer ServerID
serverID =
    fuzzer genServerID


ip : Fuzzer IP
ip =
    fuzzer genIP


noServer : Fuzzer Server
noServer =
    fuzzer genNoServer


serverData : Fuzzer ServerData
serverData =
    fuzzer genServerData


serverDataList : Fuzzer (List ServerData)
serverDataList =
    fuzzer genServerDataList


server : Fuzzer Server
server =
    fuzzer genServer


emptyServers : Fuzzer Servers
emptyServers =
    fuzzer genEmptyServers


nonEmptyServers : Fuzzer Servers
nonEmptyServers =
    fuzzer genNonEmptyServers


servers : Fuzzer Servers
servers =
    fuzzer genServers


model : Fuzzer Servers
model =
    fuzzer genModel



--------------------------------------------------------------------------------
-- Generators
--------------------------------------------------------------------------------


genServerID : Generator ServerID
genServerID =
    unique


{-| TODO: make a true IP generator
-}
genIP : Generator IP
genIP =
    RandomString.rangeLengthString 1 256 RandomChar.english


genNoServer : Generator Server
genNoServer =
    Random.constant NoServer


genServerData : Generator ServerData
genServerData =
    let
        buildServerDataRecord =
            \id ip fs logs proc ->
                { id = id
                , ip = ip
                , filesystem = fs
                , logs = logs
                , processes = proc
                }
    in
        genServerID
            |> Random.map buildServerDataRecord
            |> andMap genIP
            |> andMap Gen.Filesystem.genFilesystem
            |> andMap Gen.Logs.genLogs
            |> andMap Gen.Processes.genProcesses


genServerDataList : Generator (List ServerData)
genServerDataList =
    Random.int 1 64
        |> Random.andThen (\num -> Random.list num genServerData)


genServer : Generator Server
genServer =
    let
        genServer_ =
            Random.map StdServer genServerData
    in
        Random.choices [ genNoServer, genServer_ ]


genEmptyServers : Generator Servers
genEmptyServers =
    Random.constant initialServers


genNonEmptyServers : Generator Servers
genNonEmptyServers =
    let
        reducer =
            (List.foldl (flip addServer) initialServers) >> Random.constant
    in
        Random.andThen reducer genServerDataList


genServers : Generator Servers
genServers =
    Random.choices [ genEmptyServers, genNonEmptyServers ]


genModel : Generator Servers
genModel =
    genServers
