module Gen.Logs exposing (..)

import Random.Pcg as Random exposing (Generator)
import Fuzz exposing (Fuzzer)
import Gen.Utils exposing (..)
import Game.Servers.Logs.Models exposing (..)


--------------------------------------------------------------------------------
-- Fuzzers
--------------------------------------------------------------------------------


logID : Fuzzer LogID
logID =
    fuzzer genLogID


logContent : Fuzzer LogContent
logContent =
    fuzzer genLogContent


logEntry : Fuzzer Log
logEntry =
    fuzzer genLogEntry


noLog : Fuzzer Log
noLog =
    fuzzer genNoLog


log : Fuzzer Log
log =
    fuzzer genLog


logList : Fuzzer (List Log)
logList =
    fuzzer genLogList


emptyLogs : Fuzzer Logs
emptyLogs =
    fuzzer genEmptyLogs


nonEmptyLogs : Fuzzer Logs
nonEmptyLogs =
    fuzzer genNonEmptyLogs


logs : Fuzzer Logs
logs =
    fuzzer genLogs


model : Fuzzer Logs
model =
    fuzzer genModel



--------------------------------------------------------------------------------
-- Generators
--------------------------------------------------------------------------------


genLogID : Generator LogID
genLogID =
    unique


genLogContent : Generator LogContent
genLogContent =
    unique


genLogEntry : Generator Log
genLogEntry =
    Random.map2
        (\id content -> LogEntry { id = id, content = content })
        genLogID
        genLogContent


genNoLog : Generator Log
genNoLog =
    Random.constant NoLog


genLog : Generator Log
genLog =
    Random.choices [ genLogEntry, genNoLog ]


genLogList : Generator (List Log)
genLogList =
    Random.int 1 64
        |> Random.andThen (\num -> Random.list num genLog)


genEmptyLogs : Generator Logs
genEmptyLogs =
    Random.constant initialLogs


genNonEmptyLogs : Generator Logs
genNonEmptyLogs =
    let
        addLog_ =
            flip addLog

        reduce =
            (List.foldl addLog_ initialLogs) >> Random.constant
    in
        genLogList
            |> Random.andThen reduce


genLogs : Generator Logs
genLogs =
    Random.choices [ genEmptyLogs, genNonEmptyLogs ]


genModel : Generator Logs
genModel =
    genLogs
