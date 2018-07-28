module Game.Meta.Types.Desktop.Apps exposing (..)

{-| Aplicativos disponíveis no modo Desktop.
-}


{-| Tipos de aplicativos disponíveis no modo Desktop.
-}
type DesktopApp
    = BackFlix
    | BounceManager
    | Browser
    | Bug
    | Calculator
    | ConnManager
    | CtrlPanel
    | DBAdmin
    | Email
    | Explorer
    | Finance
    | FloatingHeads
    | Hebamp
    | LanViewer
    | LocationPicker
    | LogViewer
    | ServersGears
    | TaskManager
    | VirusPanel


{-| Referência para uma instância de aplicativo.
-}
type alias Reference =
    String


{-| Referência para uma instância de aplicativo.
-}
type alias BrowserTab =
    Int


{-| Referência para uma aba do `Browser`.
-}
type alias Requester =
    { reference : Reference
    , browserTab : BrowserTab
    }
