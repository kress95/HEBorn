module Apps.Browser.Menu.Models exposing (..)

import OS.WindowManager.MenuHandler.Models as MenuHandler


type Menu
    = MenuNav
    | MenuTab Int


type alias Model =
    MenuHandler.Model Menu


initialMenu : Model
initialMenu =
    MenuHandler.initialModel
