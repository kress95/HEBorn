module Core.Dispatch.Account exposing (..)

import Game.Servers.Shared as Servers
import Game.Meta.Types.Context exposing (Context)
import Game.Inventory.Shared as Inventory
import Game.Account.Finances.Models exposing (AccountId, BankAccount)
import Events.Account.PasswordAcquired as PasswordAcquired
import Events.Account.Finances.BankAccountOpened as BankAccountOpened
import Events.Account.Finances.BankAccountClosed as BankAccountClosed
import Events.Account.Finances.BankAccountUpdated as BankAccountUpdated


{-| Messages related to player's account.
-}
type Dispatch
    = SetGateway Servers.CId
    | SetEndpoint (Maybe Servers.CId)
    | SetContext Context
    | NewGateway Servers.CId
    | PasswordAcquired PasswordAcquired.Data
    | Finances Finances
    | LogoutAndCrash ( String, String )
    | Logout
    | Inventory Inventory


type Inventory
    = UsedInventoryEntry Inventory.Entry
    | FreedInventoryEntry Inventory.Entry


type Finances
    = BankAccountOpened ( AccountId, BankAccount )
    | BankAccountClosed AccountId
    | BankAccountUpdated ( AccountId, BankAccount )
