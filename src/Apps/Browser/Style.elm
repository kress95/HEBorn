module Apps.Browser.Style exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Utils exposing (transition, easingToString, Easing(..), pseudoContent, selectableText)
import Css.Common exposing (flexContainerVert, flexContainerHorz, internalPadding, internalPaddingSz)
import Css.Icons as Icon


type Classes
    = Window
    | Nav
    | Content
    | ContentHeader
    | ContentList
    | LocBar
    | ActBtns
    | DirBtn
    | DocBtn
    | NewBtn
    | GoUpBtn
    | BreadcrumbItem
    | CntListContainer
    | CntListEntry
    | CntListChilds
    | EntryDir
    | EntryArchive
    | EntryExpanded
    | VirusIcon
    | FirewallIcon
    | ActiveIcon
    | PassiveIcon
    | DirIcon
    | GenericArchiveIcon
    | CasedDirIcon
    | CasedOpIcon
    | NavEntry
    | NavTree
    | NavData
    | NavIcon
    | EntryView
    | EntryChilds
    | ProgBar
    | ProgFill


css : Stylesheet
css =
    (stylesheet << namespace "browser")
        []
