module Game.Meta.Types.Network.Site exposing (..)

import Game.Meta.Types.Network exposing (NIP)
import Game.Servers.Filesystem.Shared as Filesystem


{-| Endereço do Site.
-}
type alias Url =
    String


{-| Sites contém o endereço do site, tipo de site e metadados.
-}
type alias Site =
    { url : String
    , type_ : Type
    , meta : Meta
    }


{-| Metadados contém a senha do servidor, o endereço NIP e uma lista de
arquivos públicos.
-}
type alias Meta =
    { password : Maybe String
    , nip : NIP
    , publicFiles : List Filesystem.FileEntry
    }


{-| Tipos de Sites.
-}
type Type
    = NotFound
    | Home
    | Webserver WebserverContent
    | Profile
    | Whois
    | DownloadCenter DownloadCenterContent
    | ISP
    | Bank BankContent
    | Store
    | BTC
    | FBI
    | News
    | Bithub
    | MissionCenter


{-| Conteúdo do `WebserverCenter`.
-}
type alias WebserverContent =
    { custom : String }


{-| Conteúdo do `BankCenter`.
-}
type alias BankContent =
    { title : String
    , nip : NIP
    }


{-| Conteúdo do `DownloadCenter`.
-}
type alias DownloadCenterContent =
    { title : String
    }


{-| Retorna tipo do `Site`.
-}
getType : Site -> Type
getType site =
    site.type_


{-| Retorna `Url` do `Site`.
-}
getUrl : Site -> Url
getUrl site =
    site.url
