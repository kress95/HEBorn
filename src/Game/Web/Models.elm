module Game.Web.Models
    exposing
        ( Model
        , LoadingPages
        , initialModel
        , startLoading
        , finishLoading
        )

{-| Gerencia estado relacionado ao carregamento de páginas.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Desktop.Apps exposing (Requester)
import Game.Meta.Types.Network as Network
import Game.Servers.Shared as Servers exposing (CId)


{-| Gerencia estado relacionado ao carregamento de páginas.
-}
type alias Model =
    { loadingPages : LoadingPages
    }


{-| `Dict` com páginas que estão carregando.
-}
type alias LoadingPages =
    Dict Network.NIP ( CId, Requester )


{-| Model inicial.
-}
initialModel : Model
initialModel =
    { loadingPages = Dict.empty }


{-| Insere página do `Dict` de páginas carregando.
-}
startLoading : Network.NIP -> CId -> Requester -> Model -> Model
startLoading id cid requester model =
    let
        loadingPages =
            Dict.insert id ( cid, requester ) model.loadingPages
    in
        { model | loadingPages = loadingPages }


{-| Remove página do `Dict` de páginas carregando.
-}
finishLoading : Network.NIP -> Model -> ( Maybe ( CId, Requester ), Model )
finishLoading nip model =
    let
        request =
            Dict.get nip model.loadingPages

        loadingPages =
            Dict.remove nip model.loadingPages
    in
        ( request, { model | loadingPages = loadingPages } )
