module Game.Account.Bounces.Models
    exposing
        ( Model
        , Bounce
        , Path
        , initialModel
        , get
        , emptyBounce
        , insert
        , remove
        , getName
        , setName
        , getPath
        , getNameWithBounce
        , subscribeFor
        , isEmpty
        , getBounces
        , getIds
        )

{-| Armazena `Bounces` do jogador e `Bounces` otimistas.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Network as Network
import Game.Account.Bounces.Shared exposing (..)
import Game.Meta.Types.Desktop.Apps exposing (Reference)


{-| `RequestId` do `Bounce` otimista.
-}
type alias RequestId =
    String


{-| Model contém bounces e bounces otimistas.
Bounces otimistas armazenam o `AppId` de um `BounceManager` que está esperando
que um evento de `BounceCreated` chegue com um `RequestId` específico.
-}
type alias Model =
    { bounces : Dict ID Bounce
    , optimistics : Dict RequestId Reference
    }


{-| Um `Bounce` tem um nome e o caminho percorrido.
-}
type alias Bounce =
    { name : String
    , path : Path
    }


{-| Caminho que a `Bounce` percorre.
-}
type alias Path =
    List Network.NIP


{-| Retorna uma `Bounce` vazia.
-}
initialModel : Model
initialModel =
    Model Dict.empty Dict.empty


{-| Tenta encontrar um `Bounce` na `Model`.
-}
get : ID -> Model -> Maybe Bounce
get id model =
    Dict.get id model.bounces


{-| Adiciona uma subscription
-}
subscribeFor : String -> String -> Model -> Model
subscribeFor requestId appId model =
    { model | optimistics = Dict.insert requestId appId model.optimistics }


{-| Retorna uma `Bounce` vazia.
-}
emptyBounce : Bounce
emptyBounce =
    { name = "Untitled Bounce"
    , path = []
    }


{-| Insere `Bounce` na `Model`.
-}
insert : ID -> Bounce -> Model -> Model
insert id bounce model =
    { model | bounces = Dict.insert id bounce model.bounces }


{-| Remove `Bounce` da `Model`.
-}
remove : ID -> Model -> Model
remove id model =
    { model | bounces = Dict.remove id model.bounces }


{-| Tenta pegar o nome do `Bounce`.
-}
getName : ID -> Model -> Maybe String
getName id model =
    model
        |> get id
        |> Maybe.map .name


{-| Retorna nome do `Bounce`.
-}
getNameWithBounce : Bounce -> String
getNameWithBounce =
    .name


{-| Muda nome de um `Bounce`.
-}
getPath : ID -> Model -> Maybe Path
getPath id model =
    model
        |> get id
        |> Maybe.map .path


{-| Muda nome de um `Bounce`.
-}
setName : String -> Bounce -> Bounce
setName name bounce =
    { bounce | name = name }


{-| Retorna `True` quando a `Model` não conter nenhuma `Bounce`.
-}
isEmpty : Model -> Bool
isEmpty =
    .bounces >> Dict.isEmpty


{-| Lista de `ID` das bounces.
-}
getIds : Model -> List ID
getIds =
    .bounces >> Dict.keys


{-| Retorna `Dict` com bounces.
-}
getBounces : Model -> Dict ID Bounce
getBounces =
    .bounces
