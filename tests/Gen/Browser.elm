module Gen.Browser exposing (..)

import Html exposing (Html, div)
import Apps.Browser.Messages exposing (Msg(..))
import Gen.Utils exposing (..)
import Apps.Browser.Models exposing (..)
import Utils.TabList as TabList exposing (TabList)


url : Int -> String
url seedInt =
    fuzz1 seedInt urlSeed


urlSeed : StringSeed
urlSeed seed =
    smallStringSeed seed


page : Int -> BrowserPage
page seedInt =
    fuzz1 seedInt pageSeed


pageSeed : Seed -> ( BrowserPage, Seed )
pageSeed seed =
    let
        ( url, seed_ ) =
            urlSeed seed

        -- FIXME: update the content
        page =
            { url = url, content = "" }
    in
        ( page, seed )


pageListSeed : Seed -> ( List BrowserPage, Seed )
pageListSeed seed =
    let
        ( size, seed_ ) =
            intRangeSeed 1 10 seed

        list =
            List.range 0 size

        reducer =
            \_ ( pages, seed ) ->
                let
                    ( page, seed_ ) =
                        pageSeed seed
                in
                    ( page :: pages, seed_ )
    in
        List.foldl reducer ( [], seed_ ) list


emptyPage : BrowserPage
emptyPage =
    -- FIXME: update the content
    { url = "about:blank", content = "" }


history : Int -> BrowserHistory
history seedInt =
    fuzz1 seedInt historySeed


historySeed : Seed -> ( BrowserHistory, Seed )
historySeed seed =
    let
        ( list1, seed1 ) =
            pageListSeed seed

        ( list2, seed_ ) =
            pageListSeed seed1

        history =
            List.foldl TabList.pushBack TabList.empty list1

        history_ =
            List.foldl TabList.pushFront history list2
    in
        ( history_, seed_ )


browserTab : Int -> BrowserTab
browserTab seedInt =
    fuzz1 seedInt browserTabSeed


browserTabSeed : Seed -> ( BrowserTab, Seed )
browserTabSeed seed =
    let
        ( history, seed2 ) =
            historySeed seed

        ( currentPage, seed_ ) =
            pageSeed seed2

        history_ =
            TabList.pushFront currentPage history

        browser =
            browserTabParams history_ currentPage
    in
        ( browser, seed )


browserTabParams : BrowserHistory -> BrowserPage -> BrowserTab
browserTabParams history page =
    { addressBar = getPageURL page
    , history = history
    }


tabListSeed : Seed -> ( List BrowserTab, Seed )
tabListSeed seed =
    let
        ( size, seed_ ) =
            intRangeSeed 1 10 seed

        list =
            List.range 0 size

        reducer =
            \_ ( pages, seed ) ->
                let
                    ( page, seed_ ) =
                        browserTabSeed seed
                in
                    ( page :: pages, seed_ )
    in
        List.foldl reducer ( [], seed_ ) list


browser : Int -> Browser
browser seedInt =
    fuzz1 seedInt browserSeed


browserSeed : Seed -> ( Browser, Seed )
browserSeed seed =
    let
        ( list1, seed1 ) =
            tabListSeed seed

        ( list2, seed_ ) =
            tabListSeed seed1

        browser =
            List.foldl TabList.pushBack TabList.empty list1

        browser_ =
            List.foldl TabList.pushFront browser list2
    in
        ( browser_, seed_ )


emptyBrowser : Browser
emptyBrowser =
    initialBrowser


model : Int -> Browser
model seedInt =
    fuzz1 seedInt modelSeed


modelSeed : Seed -> ( Browser, Seed )
modelSeed seed =
    browserSeed seed


emptyModel : Browser
emptyModel =
    emptyBrowser
