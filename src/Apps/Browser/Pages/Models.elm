module Apps.Browser.Pages.Models
    exposing
        ( Model(..)
        , initialModel
        , getSite
        , getTitle
        )

import Game.Web.Types as Web
import Apps.Browser.Pages.NotFound.Models as PageNotFound
import Apps.Browser.Pages.Default.Models as PageDefault
import Apps.Browser.Pages.Profile.Models as PageProfile
import Apps.Browser.Pages.Whois.Models as PageWhois
import Apps.Browser.Pages.Directory.Models as PageDirectory
import Apps.Browser.Pages.MissionCenter.Models as PageMissionCenter
import Apps.Browser.Pages.DownloadCenter.Models as PageDownloadCenter
import Apps.Browser.Pages.ISP.Models as PageISP
import Apps.Browser.Pages.FBI.Models as PageFBI
import Apps.Browser.Pages.News.Models as PageNews


type Model
    = BlankModel
    | NotFoundModel PageNotFound.Model
    | UnknownModel
    | HomeModel
    | CustomModel
    | DefaultModel PageDefault.Model
    | ProfileModel
    | WhoisModel
    | DirectoryModel
    | DownloadCenterModel
    | ISPModel
    | BankModel
    | StoreModel
    | BTCModel
    | FBIModel
    | NewsModel
    | BithubModel
    | MissionCenterModel


type alias Meta =
    { url : String, title : String }


initialModel : Web.Site -> Model
initialModel ({ type_, meta } as site) =
    case ( type_, meta ) of
        ( Web.Unknown, _ ) ->
            UnknownModel

        ( Web.Blank, _ ) ->
            BlankModel

        ( Web.Home, _ ) ->
            HomeModel

        ( Web.NotFound, _ ) ->
            site
                |> PageNotFound.initialModel
                |> NotFoundModel

        -- TODO: only match pages with metadata
        ( Web.Default, _ ) ->
            site
                |> PageDefault.initialModel
                |> DefaultModel

        ( Web.Profile, _ ) ->
            ProfileModel

        ( Web.Whois, _ ) ->
            WhoisModel

        ( Web.Directory, _ ) ->
            DirectoryModel

        ( Web.MissionCenter, _ ) ->
            MissionCenterModel

        ( Web.DownloadCenter, _ ) ->
            DownloadCenterModel

        ( Web.ISP, _ ) ->
            ISPModel

        ( Web.FBI, _ ) ->
            FBIModel

        ( Web.News, _ ) ->
            NewsModel

        _ ->
            UnknownModel


getTitle : Model -> String
getTitle model =
    case model of
        NotFoundModel model ->
            PageNotFound.getTitle model

        UnknownModel ->
            "Loading..."

        HomeModel ->
            "Home"

        BlankModel ->
            "New Tab"

        ProfileModel ->
            PageProfile.getTitle

        WhoisModel ->
            PageWhois.getTitle

        DirectoryModel ->
            PageDirectory.getTitle

        MissionCenterModel ->
            PageMissionCenter.getTitle

        DownloadCenterModel ->
            PageDownloadCenter.getTitle

        ISPModel ->
            PageISP.getTitle

        FBIModel ->
            PageFBI.getTitle

        NewsModel ->
            PageNews.getTitle

        DefaultModel model ->
            PageDefault.getTitle model

        _ ->
            "Unknown Page"


getSite : Model -> ( Web.Type, Maybe Web.Meta )
getSite model =
    case model of
        NotFoundModel model ->
            PageNotFound.getSite model

        BlankModel ->
            ( Web.Blank, Nothing )

        HomeModel ->
            ( Web.Home, Nothing )

        ProfileModel ->
            PageProfile.getSite

        WhoisModel ->
            PageWhois.getSite

        DirectoryModel ->
            PageDirectory.getSite

        MissionCenterModel ->
            PageMissionCenter.getSite

        DownloadCenterModel ->
            PageDownloadCenter.getSite

        ISPModel ->
            PageISP.getSite

        FBIModel ->
            PageFBI.getSite

        NewsModel ->
            PageNews.getSite

        DefaultModel model ->
            PageDefault.getSite model

        CustomModel ->
            ( Web.Custom, Nothing )

        _ ->
            ( Web.Unknown, Nothing )
