module Apps.Browser.Models
    exposing
        ( Browser
        , BrowserTab
        , BrowserHistory
        , BrowserPage
        , PageContent
        , PageURL
        , Model
        , ContextBrowser
        , initialBrowser
        , initialModel
        , initialBrowserContext
        , getBrowserInstance
        , getBrowserContext
        , getState
        , getTab
        , getTabList
        , getPage
        , getPageURL
        , getPageContent
        , getPreviousPages
        , getNextPages
        , focusTab
        , openPage
        , gotoPage
        , gotoPreviousPage
        , gotoNextPage
        )

import Maybe as Maybe exposing (andThen, withDefault)
import Utils exposing (andJust)
import Apps.Instances.Models as Instance
    exposing
        ( Instances
        , InstanceID
        , initialState
        )
import Html exposing (Html, div, text)
import Apps.Browser.Messages exposing (Msg(..))
import Apps.Context as Context exposing (ContextApp)
import Apps.Browser.Context.Models as Menu
import Utils.TabList as TabList exposing (TabList)


type alias PageURL =
    String


type alias PageContent =
    String


type alias BrowserPage =
    { url : PageURL
    , content : PageContent
    }


type alias BrowserHistory =
    TabList BrowserPage


type alias BrowserTab =
    { addressBar : String
    , history : BrowserHistory
    }


type alias Browser =
    TabList BrowserTab


type alias ContextBrowser =
    ContextApp Browser


type alias Model =
    { instances : Instances ContextBrowser
    , menu : Menu.Model
    }


initialPage : BrowserPage
initialPage =
    { url = "about:blank", content = "" }


initialBrowser : Browser
initialBrowser =
    TabList.singleton (newTab initialPage)


initialModel : Model
initialModel =
    { instances = initialState
    , menu = Menu.initialContext
    }


initialBrowserContext : ContextBrowser
initialBrowserContext =
    Context.initialContext initialBrowser


getBrowserInstance : Instances ContextBrowser -> InstanceID -> ContextBrowser
getBrowserInstance model id =
    case (Instance.get model id) of
        Just instance ->
            instance

        Nothing ->
            initialBrowserContext


getBrowserContext : ContextApp Browser -> Browser
getBrowserContext instance =
    case (Context.state instance) of
        Just context ->
            context

        Nothing ->
            initialBrowser


getState : Model -> InstanceID -> Browser
getState model id =
    getBrowserContext
        (getBrowserInstance model.instances id)


getTab : Browser -> Maybe BrowserTab
getTab browser =
    TabList.current browser


getTabList : Browser -> List BrowserTab
getTabList browser =
    TabList.toList browser


getPage : BrowserTab -> Maybe BrowserPage
getPage tab =
    TabList.current tab.history


getPageURL : BrowserPage -> PageURL
getPageURL page =
    page.url


getPageContent : BrowserPage -> PageContent
getPageContent page =
    page.content


getPreviousPages : BrowserTab -> List BrowserPage
getPreviousPages tab =
    TabList.back tab.history


getNextPages : BrowserTab -> List BrowserPage
getNextPages tab =
    TabList.front tab.history


focusTab : Int -> Browser -> Browser
focusTab tabIndex browser =
    TabList.focus tabIndex browser


openPage : BrowserPage -> Browser -> Browser
openPage page browser =
    TabList.pushFront (newTab page) browser


gotoPage : BrowserPage -> Browser -> Browser
gotoPage page browser =
    let
        maybePage =
            case getTab browser of
                Just tab ->
                    getPage tab

                Nothing ->
                    Nothing
    in
        case maybePage of
            Just page_ ->
                if page /= page_ then
                    -- browser
                    -- |> getTab
                    -- |> andThen (\tab TabList.pushFront page )
                    -- |> andJust updateTab
                    -- |> andJust
                    --     (\tab ->
                    --         browser
                    --             |> TabList.drop
                    --             |> TabList.pushFront tab
                    --     )
                    -- |> withDefault browser
                    browser
                else
                    browser



-- case maybePage of
--     Just page ->
--         let
--             tab_ =
--                 tab.history
--                     |> TabList.pushFront page
--                     |> updateTab tab
--         in
--             browser
--                 |> TabList.drop
--                 |> TabList.pushFront tab_
--     Nothing ->
--         browser


gotoPreviousPage : Browser -> Browser
gotoPreviousPage =
    moveHistory TabList.backward


gotoNextPage : Browser -> Browser
gotoNextPage =
    moveHistory TabList.forward


newTab : BrowserPage -> BrowserTab
newTab page =
    { addressBar = getPageURL page
    , history = TabList.singleton page
    }


updateTab : BrowserTab -> BrowserHistory -> BrowserTab
updateTab tab history =
    case TabList.current history of
        Just page ->
            { tab | addressBar = getPageURL page, history = history }

        Nothing ->
            tab

updatePage : BrowserPage -> Browser -> Browser
updatePage page browser =
    case getTab browser ->
        Just tab ->
            -- page.
            -- TabList.pushFront 
            -- case getPage tab ->
            --     Just page ->
                    
            --     Nothing ->
            --         browser
        Nothing ->
            browser

moveHistory : (BrowserHistory -> BrowserHistory) -> Browser -> Browser
moveHistory fun browser =
    case TabList.current browser of
        Just tab ->
            let
                tab_ =
                    tab.history
                        |> fun
                        |> updateTab tab
            in
                browser
                    |> TabList.drop
                    |> TabList.pushFront tab_

        Nothing ->
            browser
