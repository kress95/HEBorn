module Game.Meta.Types.Components.Motherboard.Diff exposing (Diff, diff)

{-| Utilizado para comparar duas `Motherboard`, enumerando os componentes
utilizados e liberados entre as duas.
-}

import Dict exposing (Dict)
import Set exposing (Set)
import Game.Inventory.Shared as Inventory
import Game.Meta.Types.Components.Motherboard as Motherboard exposing (Motherboard)
import Game.Meta.Types.Components as Components


{-| Listas de diferenças entre duas `Motherboard`, o primeiro índice da tupla
contém os componentes utilizados, o segundo contém os liberados.
-}
type alias Diff =
    ( List Inventory.Entry, List Inventory.Entry )


{-| Formato de diff utilizado internamente, utilizando `Set` por questões de
legibilidade e performance.
-}
type alias InternalDiff comparable =
    ( Set comparable, Set comparable )


{-| Retorna as diferenças entre duas `Motherboard`.
-}
diff :
    Motherboard
    -> Motherboard
    -> Diff
diff next previous =
    let
        slots =
            previous
                |> toLinkedComponents
                |> diffHelper (toLinkedComponents next)
                |> fromInternalDiff
                |> map Inventory.Component

        ncs =
            previous
                |> Motherboard.getNCs
                |> diffHelper (Motherboard.getNCs next)
                |> fromInternalDiff
                |> map Inventory.NetConnection
    in
        join slots ncs



-- funções internas


{-| Realiza uma comparação mais inteligente que inclui slots não presentes na
nova `Motherboard`.
-}
diffHelper :
    Dict comparable1 comparable2
    -> Dict comparable1 comparable2
    -> InternalDiff comparable2
diffHelper next previous =
    next
        |> Dict.diff previous
        |> Dict.values
        |> List.foldl remove empty
        |> flip (Dict.foldl (diffReducer previous)) next


{-| Compara conteúdo de slots com o conteúdo da `Motherboard` anterior.
-}
diffReducer :
    Dict comparable1 comparable2
    -> comparable1
    -> comparable2
    -> InternalDiff comparable2
    -> InternalDiff comparable2
diffReducer old id component diff =
    case Dict.get id old of
        Just previous ->
            if component /= previous then
                diff
                    |> remove previous
                    |> insert component
            else
                diff

        Nothing ->
            insert component diff


{-| Converte `Motherboard` em um `Dict` com slots associados aos componentes.
-}
toLinkedComponents : Motherboard -> Dict Motherboard.SlotId Components.Id
toLinkedComponents =
    let
        reducer id slot dict =
            case Motherboard.getSlotComponent slot of
                Just component ->
                    Dict.insert id component dict

                Nothing ->
                    dict
    in
        Motherboard.getSlots >> Dict.foldl reducer Dict.empty


{-| Mapeia ambos os lados da lista de diferenças.
-}
map : (a -> b) -> ( List a, List a ) -> ( List b, List b )
map f ( add, rem ) =
    ( List.map f add, List.map f rem )


{-| Retorna uma lista de diferenças vazia.
-}
empty : InternalDiff comparable
empty =
    ( Set.empty, Set.empty )


{-| Adiciona um componente a lista de componentes utilizados.
-}
insert : comparable -> InternalDiff comparable -> InternalDiff comparable
insert item ( add, rem ) =
    ( Set.insert item add, Set.remove item rem )


{-| Adiciona um componente a lista de componentes liberados, mas só quando ele
não fizer parte da lista de componentes utilizados.
-}
remove : comparable -> InternalDiff comparable -> InternalDiff comparable
remove item ( add, rem ) =
    if Set.member item add then
        ( add, rem )
    else
        ( add, Set.insert item rem )


{-| Converte uma lista de diferenças interna em uma lista de diferenças
pública.
-}
fromInternalDiff : InternalDiff comparable -> ( List comparable, List comparable )
fromInternalDiff ( add, rem ) =
    ( Set.toList add, Set.toList rem )


{-| Junta duas listas de diferenças em uma só.
-}
join : ( List a, List a ) -> ( List a, List a ) -> ( List a, List a )
join ( add1, rem1 ) ( add2, rem2 ) =
    ( add1 ++ add2
    , rem1 ++ rem2
    )
