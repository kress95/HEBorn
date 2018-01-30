module OS.WindowManager.Config exposing (..)

import Time exposing (Time)
import Utils.Core exposing (..)
import Game.Meta.Types.Apps.Desktop as DesktopApp exposing (DesktopApp)
import Game.Account.Models as Account
import Game.Account.Bounces.Shared as Bounces
import Game.Account.Finances.Models as Finances
import Game.Account.Notifications.Shared as AccountNotifications
import Game.BackFlix.Models as BackFlix
import Game.Inventory.Models as Inventory
import Game.Meta.Types.Components.Motherboard as Motherboard exposing (Motherboard)
import Game.Meta.Types.Context exposing (Context(..))
import Game.Meta.Types.Requester exposing (Requester)
import Game.Meta.Types.Network as Network exposing (NIP)
import Game.Servers.Models as Servers
import Game.Servers.Shared as Servers exposing (CId, StorageId)
import Game.Servers.Filesystem.Shared as Filesystem
import Game.Servers.Logs.Models as Logs
import Game.Servers.Processes.Models as Processes
import Game.Storyline.Models as Story
import Game.Storyline.Emails.Contents as Emails
import OS.WindowManager.Dock.Config as Dock
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Shared exposing (..)


type alias Config msg =
    { toMsg : Msg -> msg
    , batchMsg : List msg -> msg
    , onSetBounce : Maybe Bounces.ID -> msg
    , onNewPublicDownload : NIP -> StorageId -> Filesystem.FileEntry -> msg
    , onBankAccountLogin : Finances.BankLoginRequest -> Requester -> msg
    , onBankAccountTransfer : Finances.BankTransferRequest -> Requester -> msg
    , onAccountToast : AccountNotifications.Content -> msg
    , onPoliteCrash : ( String, String ) -> msg
    , onNewTextFile : CId -> StorageId -> Filesystem.Path -> Filesystem.Name -> msg
    , onNewDir : CId -> StorageId -> Filesystem.Path -> Filesystem.Name -> msg
    , onMoveFile : CId -> StorageId -> Filesystem.Id -> Filesystem.Path -> msg
    , onRenameFile : CId -> StorageId -> Filesystem.Id -> Filesystem.Name -> msg
    , onDeleteFile : CId -> StorageId -> Filesystem.Id -> msg
    , onUpdateLog : CId -> Logs.ID -> String -> msg
    , onEncryptLog : CId -> Logs.ID -> msg
    , onHideLog : CId -> Logs.ID -> msg
    , onDeleteLog : CId -> Logs.ID -> msg
    , onMotherboardUpdate : CId -> Motherboard -> msg
    , onPauseProcess : CId -> Processes.ID -> msg
    , onResumeProcess : CId -> Processes.ID -> msg
    , onRemoveProcess : CId -> Processes.ID -> msg
    , onSetContext : Context -> msg
    , onNewBruteforceProcess : CId -> Network.IP -> msg
    , onWebLogin : NIP -> Network.IP -> String -> Requester -> msg
    , onFetchUrl : CId -> Network.ID -> Network.IP -> Requester -> msg
    , onReplyEmail : String -> Emails.Content -> msg
    , onActionDone : DesktopApp -> Context -> msg
    , onWebLogout : CId -> msg
    , lastTick : Time
    , isCampaign : Bool
    , activeContext : Context
    , endpointCId : Maybe Servers.CId
    , activeGateway : ( Servers.CId, Servers.Server )
    , activeServer : ( Servers.CId, Servers.Server )
    , story : Story.Model
    , servers : Servers.Model
    , account : Account.Model
    , inventory : Inventory.Model
    , backFlix : BackFlix.BackFlix
    }


dockConfig : Config msg -> Dock.Config msg
dockConfig config =
    { onClickIcon = ClickIcon >> config.toMsg
    , onMinimizeAll = MinimizeAll >> config.toMsg
    , onCloseAll = CloseAll >> config.toMsg
    , onMinimizeWindow = Minimize >> config.toMsg
    , onRestoreWindow = Just >> UpdateFocus >> config.toMsg
    , onCloseWindow = CloseWindow >> config.toMsg
    , accountDock = Account.getDock config.account
    , endpointCId = config.endpointCId
    }
