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
    { front : List a
    , back : List a
    , index : Int
    }


empty : TabList a
empty =
    { front = [], back = [], index = 0 }


isEmpty : TabList a -> Bool
isEmpty { index, front } =
    (index == 0) && (List.isEmpty front)


length : TabList a -> Int
length { index, front } =
    index + (List.length front)


singleton : a -> TabList a
singleton head =
    { front = [ head ], back = [], index = 0 }


current : TabList a -> Maybe a
current { front } =
    List.head front


put : a -> TabList a -> TabList a
put item list =
    let
        { front } =
            list
    in
        { list | front = item :: front }


drop : TabList a -> TabList a
drop list =
    let
        { front } =
            list
    in
        case List.tail front of
            Just tail ->
                { list | front = tail }

            Nothing ->
                backward { list | front = [] }


dropLeft : TabList a -> TabList a
dropLeft { front } =
    { front = front, back = [], index = 0 }


dropRight : TabList a -> TabList a
dropRight list =
    let
        { front } =
            list
    in
        case List.head front of
            Just head ->
                { list | front = [ head ] }

            Nothing ->
                backward { list | front = [] }


push : a -> TabList a -> TabList a
push item list =
    let
        { front } =
            list

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
        { list | front = front_ }


front : TabList a -> List a
front { front } =
    front
        |> List.tail
        |> Maybe.withDefault []


back : TabList a -> List a
back { back } =
    back


forward : TabList a -> TabList a
forward list =
    let
        { front, back, index } =
            list
    in
        case List.head front of
            Just item ->
                let
                    front_ =
                        front
                            |> List.tail
                            |> Maybe.withDefault ([])
                in
                    { front = front_, back = item :: back, index = index + 1 }

            Nothing ->
                list


backward : TabList a -> TabList a
backward list =
    let
        { front, back, index } =
            list
    in
        case List.head back of
            Just item ->
                let
                    back_ =
                        back
                            |> List.tail
                            |> Maybe.withDefault ([])
                in
                    { front = item :: front, back = back_, index = index - 1 }

            Nothing ->
                list


toList : TabList a -> List a
toList { back, front } =
    List.foldr (::) back front


toIndexedList : TabList a -> List ( a, Int )
toIndexedList { front, back } =
    let
        ( back_, length ) =
            back
                |> List.reverse
                |> withIndex 0

        ( front_, _ ) =
            withIndex length front
    in
        List.foldr (::) (List.reverse back_) front_


map : (a -> a) -> TabList a -> TabList a
map fun list =
    let
        { front, back } =
            list

        front_ =
            List.map fun front

        back_ =
            List.map fun back
    in
        { list | front = front_, back = back_ }


indexedMap : (( a, Int ) -> a) -> TabList a -> TabList a
indexedMap fun list =
    indexedApply List.map fun list


filter : (a -> Bool) -> TabList a -> TabList a
filter fun { front, back } =
    let
        front_ =
            List.filter fun front

        back_ =
            List.filter fun back

        index =
            List.length back_
    in
        { front = front_, back = back, index = index }


withIndex : Int -> List a -> ( List ( a, Int ), Int )
withIndex initial list =
    let
        reducer =
            \item ( list, index ) -> ( ( item, index ) :: list, index + 1 )
    in
        List.foldl reducer ( [], initial ) list


indexedApply :
    (b -> List ( a, Int ) -> List c)
    -> b
    -> TabList a
    -> TabList c
indexedApply operation fun list =
    let
        { front, back } =
            list

        ( revBack, index ) =
            back
                |> List.reverse
                |> withIndex 0

        ( revFront, _ ) =
            withIndex index front

        back_ =
            revBack
                |> operation fun
                |> List.reverse

        front_ =
            operation fun revFront
    in
        { front = front_, back = back_, index = index }
