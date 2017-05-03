module Utils.TabList
    exposing
        ( TabList
        , empty
        , isEmpty
        , length
        , singleton
        , current
        , put
        , drop
        , dropLeft
        , dropRight
        , push
        , front
        , back
        , forward
        , backward
        , toList
        , toIndexedList
        , map
        , indexedMap
        , filter
        )

import Maybe exposing (Maybe)


type alias TabList a =
    ( List a, List a )


empty : TabList a
empty =
    ( [], [] )


isEmpty : TabList a -> Bool
isEmpty ( back, front ) =
    (List.isEmpty back) && (List.isEmpty front)


length : TabList a -> Int
length ( back, front ) =
    (List.length back) + (List.length front)


singleton : a -> TabList a
singleton head =
    ( [], [ head ] )


current : TabList a -> Maybe a
current ( _, front ) =
    List.head front


put : a -> TabList a -> TabList a
put item ( back, front ) =
    ( back, item :: front )


drop : TabList a -> TabList a
drop ( back, front ) =
    case List.tail front of
        Just tail ->
            ( back, tail )

        Nothing ->
            backward ( back, [] )


dropLeft : TabList a -> TabList a
dropLeft ( _, front ) =
    ( [], front )


dropRight : TabList a -> TabList a
dropRight ( back, front ) =
    case List.head front of
        Just head ->
            ( back, [ head ] )

        Nothing ->
            backward ( back, [] )


push : a -> TabList a -> TabList a
push item ( back, front ) =
    let
        tail =
            front
                |> List.tail
                |> Maybe.withDefault ([])

        front_ =
            case List.head front of
                Just head ->
                    head :: (item :: tail)

                Nothing ->
                    item :: tail
    in
        ( back, front_ )


front : TabList a -> List a
front ( _, front ) =
    front
        |> List.tail
        |> Maybe.withDefault []


back : TabList a -> List a
back ( back, _ ) =
    back


forward : TabList a -> TabList a
forward ( back, front ) =
    case List.head front of
        Just item ->
            let
                front_ =
                    front
                        |> List.tail
                        |> Maybe.withDefault ([])
            in
                ( item :: back, front_ )

        Nothing ->
            ( back, front )


backward : TabList a -> TabList a
backward ( back, front ) =
    let
        ( front_, back_ ) =
            forward ( front, back )
    in
        ( back_, front_ )


toList : TabList a -> List a
toList ( back, front ) =
    List.foldr (::) back front


toIndexedList : TabList a -> List ( a, Int )
toIndexedList ( back, front ) =
    let
        ( back_, length ) =
            back
                |> List.reverse
                |> index 0

        ( front_, _ ) =
            index length front
    in
        List.foldr (::) (List.reverse back_) front_


map : (a -> a) -> TabList a -> TabList a
map fun ( back, front ) =
    ( List.map fun back, List.map fun front )


indexedMap : (( a, Int ) -> a) -> TabList a -> TabList a
indexedMap fun list =
    indexedApply List.map fun list


filter : (a -> Bool) -> TabList a -> TabList a
filter fun ( back, front ) =
    ( List.filter fun back, List.filter fun front )


index : Int -> List a -> ( List ( a, Int ), Int )
index initial list =
    let
        reducer =
            \item ( list, index ) -> ( ( item, index ) :: list, index + 1 )
    in
        List.foldl reducer ( [], initial ) list


indexedApply :
    (b -> List ( a, Int ) -> List a1)
    -> b
    -> ( List a, List a )
    -> ( List a1, List a1 )
indexedApply operation fun ( back, front ) =
    let
        ( revBack, length ) =
            back
                |> List.reverse
                |> index 0

        ( revFront, _ ) =
            index length front

        back_ =
            revBack
                |> operation fun
                |> List.reverse

        front_ =
            operation fun revFront
    in
        ( back_, front_ )
