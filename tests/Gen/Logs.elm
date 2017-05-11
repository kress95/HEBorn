module Gen.Logs exposing (..)

import Random.Pcg
    exposing
        ( Generator
        , constant
        , int
        , map2
        , choices
        , andThen
        , list
        )
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
    stringRange 0 32


genLogEntry : Generator Log
genLogEntry =
    map2
        (\id content -> LogEntry { id = id, content = content })
        genLogID
        genLogContent


genNoLog : Generator Log
genNoLog =
    constant NoLog


genLog : Generator Log
genLog =
    choices [ genLogEntry, genNoLog ]


genLogList : Generator (List Log)
genLogList =
    andThen (genLog |> flip list) (int 1 10)


genEmptyLogs : Generator Logs
genEmptyLogs =
    constant initialLogs


genNonEmptyLogs : Generator Logs
genNonEmptyLogs =
    andThen ((List.foldl addLog initialLogs) >> constant) genLogList


genLogs : Generator Logs
genLogs =
    choices [ genEmptyLogs, genNonEmptyLogs ]


genModel : Generator Logs
genModel =
    genNonEmptyLogs
