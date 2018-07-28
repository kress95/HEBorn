module Game.Meta.Types.Components exposing (..)

{-| Funções e tipos relacionados a um componente.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Components.Type exposing (..)
import Game.Meta.Types.Components.Specs as Specs exposing (Spec)


{-| `Id` de um componente.
-}
type alias Id =
    String


{-| `Dict` que guarda componentes.
-}
type alias Components =
    Dict Id Component


{-| Componentes contém a especificação do componente, sua durabilidade e sua
disponibilidade.
-}
type alias Component =
    { spec : Spec
    , durability : Float
    , available : Bool
    }


{-| Retorna um `Dict` de componentes vazio.
-}
empty : Components
empty =
    Dict.empty


{-| Tenta pegar um `Component` do `Dict` de componentes.
-}
get : Id -> Components -> Maybe Component
get =
    Dict.get


{-| Verifica se componente é membro do `Dict` de componentes.
-}
member : Id -> Components -> Bool
member =
    Dict.member


{-| Insere componente no `Dict` de componentes.
-}
insert : Id -> Component -> Components -> Components
insert =
    Dict.insert


{-| Remove componente do `Dict` de componentes.
-}
remove : Id -> Components -> Components
remove =
    Dict.remove


{-| Retorna nome do componente.
-}
setAvailable : Bool -> Component -> Component
setAvailable available component =
    { component | available = available }


{-| Retorna nome do componente.
-}
getName : Component -> String
getName =
    getSpec >> Specs.getName


{-| Retorna descrição do componente.
-}
getDescription : Component -> String
getDescription =
    getSpec >> Specs.getDescription


{-| Retorna durabilidade do componente.
-}
getDurability : Component -> Float
getDurability =
    .durability


{-| Retorna especificação do componente.
-}
getSpec : Component -> Spec
getSpec =
    .spec


{-| Retorna tipo do componente.
-}
getType : Component -> Type
getType =
    getSpec >> Specs.toType


{-| Retorna se um componente está disponível para uso.
-}
isAvailable : Component -> Bool
isAvailable =
    .available
