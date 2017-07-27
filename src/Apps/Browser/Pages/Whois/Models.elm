module Apps.Browser.Pages.Whois.Models
    exposing
        ( getTitle
        , getSite
        )

import Game.Web.Types as Web


getTitle : String
getTitle =
    "Whois"


getSite : ( Web.Type, Maybe Web.Meta )
getSite =
    ( Web.Whois, Nothing )
