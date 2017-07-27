module Game.Web.Dummy exposing (..)

import Game.Web.Types exposing (..)


dummy : List String -> Type
dummy req =
    case req of
        "baixaki" :: "directory" :: _ ->
            Directory

        "baixaki" :: _ ->
            DownloadCenter

        "profile" :: _ ->
            Profile

        "whois" :: _ ->
            Whois

        "meuisp" :: _ ->
            ISP

        "fbi" :: _ ->
            FBI

        "lulapresoamanha" :: _ ->
            News

        "headquarters" :: _ ->
            MissionCenter

        -- TODO: remove google dummies, they are just a simulation of
        -- vpc website
        "google" :: "panel" :: _ ->
            HackPanel

        "google" :: _ ->
            Default

        _ ->
            Unknown
