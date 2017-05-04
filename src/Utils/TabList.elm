module Utils.TabList
    exposing
        ( TabList
        , empty
        , isEmpty
        , length
        , singleton
        , current
        , focus
        , putAside
        , pushFront
        , pushBack
        , drop
        , dropLeft
        , dropRight
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


drop : TabList a -> TabList a
drop ({ front } as list) =
    case List.tail front of
        Just tail ->
            { list | front = tail }

        Nothing ->
            backward { list | front = [] }


dropLeft : TabList a -> TabList a
dropLeft { front } =
    { front = front, back = [], index = 0 }


dropRight : TabList a -> TabList a
dropRight ({ front } as list) =
    case List.head front of
        Just head ->
            { list | front = [ head ] }

        Nothing ->
            backward { list | front = [] }


pushFront : a -> TabList a -> TabList a
pushFront item ({ front } as list) =
    { list | front = item :: front }


pushBack : a -> TabList a -> TabList a
pushBack item ({ back, index } as list) =
    { list | back = item :: back, index = index + 1 }


putAside : a -> TabList a -> TabList a
putAside item ({ front } as list) =
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
forward ({ front, back, index } as list) =
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
backward ({ front, back, index } as list) =
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
map fun ({ front, back } as list) =
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


focus : Int -> TabList a -> TabList a
focus position ({ front, back, index } as list) =
    let
        relativeIndex =
            position - index

        itemIndex =
            abs relativeIndex
    in
        if relativeIndex > 0 then
            -- focus item after the current one
            let
                front_ =
                    List.drop itemIndex front

                append =
                    List.take itemIndex front

                back_ =
                    back ++ append

                index_ =
                    index + (List.length append)
            in
                { front = front_, back = back_, index = index_ }
        else if relativeIndex < 0 then
            -- focus item before the current one
            let
                prepend =
                    List.drop itemIndex back

                front_ =
                    prepend ++ front

                back_ =
                    List.take itemIndex back

                index_ =
                    List.length back_
            in
                { front = front_, back = back_, index = index_ }
        else
            -- already focused
            list


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
indexedApply operation fun ({ front, back } as list) =
    let
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
