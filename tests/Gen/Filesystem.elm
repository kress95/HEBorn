module Gen.Filesystem exposing (..)

import Random.Pcg.Char as RandomChar
import Random.Pcg.String as RandomString
import Random.Pcg.Extra as RandomExtra exposing (andMap)
import Random.Pcg as Random exposing (Generator)
import Fuzz exposing (Fuzzer)
import Game.Servers.Filesystem.Models exposing (..)
import Gen.Utils exposing (..)
import Helper.Filesystem as Helper


--------------------------------------------------------------------------------
-- Fuzzers
--------------------------------------------------------------------------------


fileID : Fuzzer FileID
fileID =
    fuzzer genFileID


name : Fuzzer String
name =
    fuzzer genName


path : Fuzzer String
path =
    fuzzer genPath


extension : Fuzzer String
extension =
    fuzzer genExtension


noSize : Fuzzer FileSize
noSize =
    fuzzer genNoSize


fileSizeNumber : Fuzzer FileSize
fileSizeNumber =
    fuzzer genFileSizeNumber


fileSize : Fuzzer FileSize
fileSize =
    fuzzer genFileSize


noVersion : Fuzzer FileVersion
noVersion =
    fuzzer genNoVersion


fileVersionNumber : Fuzzer FileVersion
fileVersionNumber =
    fuzzer genFileVersionNumber


fileVersion : Fuzzer FileVersion
fileVersion =
    fuzzer genFileVersion


folder : Fuzzer File
folder =
    fuzzer genFolder


stdFile : Fuzzer File
stdFile =
    fuzzer genStdFile


file : Fuzzer File
file =
    fuzzer genFile


fileList : Fuzzer (List File)
fileList =
    fuzzer genFileList


emptyFilesystem : Fuzzer Filesystem
emptyFilesystem =
    fuzzer genEmptyFilesystem


nonEmptyFilesystem : Fuzzer Filesystem
nonEmptyFilesystem =
    fuzzer genNonEmptyFilesystem


filesystem : Fuzzer Filesystem
filesystem =
    fuzzer genFilesystem


model : Fuzzer Filesystem
model =
    fuzzer genModel



--------------------------------------------------------------------------------
-- Generators
--------------------------------------------------------------------------------


genFileID : Generator FileID
genFileID =
    unique


genName : Generator String
genName =
    RandomString.rangeLengthString 1 256 RandomChar.english


genPath : Generator String
genPath =
    genName
        |> RandomExtra.rangeLengthList 1 10
        |> Random.map (\paths -> "/" ++ (String.join "/" paths))


genExtension : Generator String
genExtension =
    RandomString.string 3 RandomChar.english


genNoSize : Generator FileSize
genNoSize =
    Random.constant NoSize


genFileSizeNumber : Generator FileSize
genFileSizeNumber =
    Random.int 1 1024
        |> Random.map FileSizeNumber


genFileSize : Generator FileSize
genFileSize =
    Random.choices [ genNoSize, genFileSizeNumber ]


genNoVersion : Generator FileVersion
genNoVersion =
    Random.constant NoVersion


genFileVersionNumber : Generator FileVersion
genFileVersionNumber =
    Random.int 1 999
        |> Random.map FileVersionNumber


genFileVersion : Generator FileVersion
genFileVersion =
    Random.choices [ genNoVersion, genFileVersionNumber ]


genFolder : Generator File
genFolder =
    let
        buildFolderRecord =
            \id name path ->
                Folder
                    { id = id
                    , name = name
                    , path = path
                    }
    in
        genFileID
            |> Random.map buildFolderRecord
            |> andMap genName
            |> andMap genPath


genStdFile : Generator File
genStdFile =
    let
        buildStdFileRecord =
            \id name path extension version size ->
                StdFile
                    { id = id
                    , name = name
                    , path = path
                    , extension = extension
                    , version = version
                    , size = size
                    , modules = []
                    }
    in
        genFileID
            |> Random.map buildStdFileRecord
            |> andMap genName
            |> andMap genPath
            |> andMap genExtension
            |> andMap genFileVersion
            |> andMap genFileSize


genFile : Generator File
genFile =
    Random.choices [ genFolder, genStdFile ]


genFileList : Generator (List File)
genFileList =
    Random.int 1 64
        |> Random.andThen (\num -> Random.list num genFile)


genEmptyFilesystem : Generator Filesystem
genEmptyFilesystem =
    Random.constant initialFilesystem


genNonEmptyFilesystem : Generator Filesystem
genNonEmptyFilesystem =
    let
        reducer =
            List.foldl Helper.addFileRecursively initialFilesystem
    in
        Random.andThen (reducer >> Random.constant) genFileList


genFilesystem : Generator Filesystem
genFilesystem =
    Random.choices [ genEmptyFilesystem, genNonEmptyFilesystem ]


genModel : Generator Filesystem
genModel =
    genFilesystem
