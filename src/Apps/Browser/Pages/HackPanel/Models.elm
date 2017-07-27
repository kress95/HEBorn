module Apps.Browser.Pages.HackPanel.Models
    exposing
        ( Model
        , getTitle
        , getSite
        )

import Game.Web.Types as Web


type alias Model =
    { title : String
    , site : Web.Site
    }


getTitle : String
getTitle =
    "Control Panel"


getSite : ( Web.Type, Maybe Web.Meta )
getSite =
    ( Web.HackPanel, Nothing )
