module Game.Servers.Filesystem.Models
    exposing
        ( Filesystem
        , initialFilesystem
        , File(..)
        , FileID
        , FilePath
        , FileSize(..)
        , FileVersion(..)
        , FileModules
        , FileModule
        , ModuleName
        , ModuleVersion
        , addFile
        , removeFile
        , getFilePath
        , getFileName
        , getFileId
        , getFilesOnPath
        , pathExists
        , rootPath
        , listFilesystem
        , moveFile
        , setFilePath
        , pathSeparator
        )

import Dict
import Game.Shared exposing (ID)


type alias FileID =
    ID


{-| todo: how about FilePath as a List String?
-}
type alias FilePath =
    String


type FileVersion
    = FileVersionNumber Int
    | NoVersion


type FileSize
    = FileSizeNumber Int
    | NoSize


type alias StdFileData =
    { id : FileID
    , name : String
    , extension : String
    , version : FileVersion
    , size : FileSize
    , path : FilePath
    , modules : FileModules
    }


type alias FileModules =
    List FileModule


type alias FileModule =
    { name : ModuleName
    , version : ModuleVersion
    }


type alias ModuleName =
    String


type alias ModuleVersion =
    Int


type alias FolderData =
    { id : FileID
    , name : String
    , path : FilePath
    }


type File
    = StdFile StdFileData
    | Folder FolderData


type alias Filesystem =
    Dict.Dict FilePath (List File)


getFileModules : File -> FileModules
getFileModules file =
    case file of
        StdFile file_ ->
            file_.modules

        Folder folder ->
            []


getFileId : File -> FileID
getFileId file =
    case file of
        StdFile file_ ->
            file_.id

        Folder folder ->
            folder.id


getFilePath : File -> FilePath
getFilePath file =
    case file of
        StdFile file_ ->
            file_.path

        Folder folder ->
            folder.path


setFilePath : File -> FilePath -> File
setFilePath file path =
    case file of
        StdFile file ->
            StdFile { file | path = path }

        Folder folder ->
            Folder { folder | path = path }


getFileName : File -> String
getFileName file =
    case file of
        StdFile file_ ->
            file_.name

        Folder folder ->
            folder.name


addFile : Filesystem -> File -> Filesystem
addFile filesystem file =
    let
        path =
            getFilePath file

        files =
            file :: (getFilesOnPath filesystem path)
    in
        case file of
            StdFile _ ->
                if (pathExists filesystem path) then
                    Dict.insert path files filesystem
                else
                    filesystem

            -- when adding a new folder we also need to insert a new
            -- path to hold it's files
            Folder _ ->
                filesystem
                    |> Dict.insert path files
                    |> Dict.insert (fullFilePath file) []


getFilesOnPath : Filesystem -> FilePath -> List File
getFilesOnPath filesystem path =
    case Dict.get path filesystem of
        Just files ->
            files

        Nothing ->
            []


pathExists : Filesystem -> FilePath -> Bool
pathExists filesystem path =
    case Dict.get path filesystem of
        Just _ ->
            True

        Nothing ->
            False


moveFile : Filesystem -> File -> FilePath -> Filesystem
moveFile filesystem file path =
    if not (pathExists filesystem path) then
        -- Moving to a non-existing path
        filesystem
    else
        let
            file_ =
                setFilePath file path

            filesystem1 =
                addFile filesystem file_

            filesystem_ =
                removeFile filesystem1 file
        in
            filesystem_


removeFile : Filesystem -> File -> Filesystem
removeFile filesystem file =
    let
        path =
            getFilePath file

        id =
            getFileId file

        filesOnPath =
            getFilesOnPath filesystem path

        newFiles =
            List.filter (\x -> (getFileId x) /= id) filesOnPath

        filesystem_ =
            case file of
                StdFile _ ->
                    Dict.insert path newFiles filesystem

                {- Deleting a folder is a special case. If there are any files
                   inside the folder, it can't be deleted at all. On the other hand,
                   if there are no files, the whole path should be deleted
                -}
                Folder _ ->
                    if List.isEmpty newFiles then
                        Dict.remove path filesystem
                    else
                        filesystem
    in
        filesystem_


listFilesystem : Filesystem -> String
listFilesystem filesystem =
    toString filesystem


initialFilesystem : Filesystem
initialFilesystem =
    Dict.empty


rootPath : FilePath
rootPath =
    "/"


pathSeparator : String
pathSeparator =
    "/"


fullFilePath : File -> String
fullFilePath file =
    let
        name =
            getFileName file

        path =
            getFilePath file
    in
        case file of
            StdFile _ ->
                -- TODO: add extension
                path ++ pathSeparator ++ name

            Folder _ ->
                path ++ pathSeparator ++ name
