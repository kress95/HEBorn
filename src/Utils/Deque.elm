module Utils.Deque
    exposing
        ( Deque
        , empty
          --
        , isEmpty
        , length
        , reverse
        , member
          --
        , singleton
          --
        , nth
        , current
        , rear
        , front
        , clearRear
        , clearFront
          --
        , toList
        , toIndexedList
          --
        , map
        , filter
        , rollForward
        , rollBackward
        , cons
          --
        , indexedMap
        )

import Maybe as Maybe exposing (Maybe)


type alias Deque a =
    { front : List a
    , rear : List a
    , rearLength : Int
    }


empty : Deque a
empty =
    { front = []
    , rear = []
    , rearLength = 0
    }


singleton : a -> Deque a
singleton item =
    { front = [ item ]
    , rear = []
    , rearLength = 0
    }


isEmpty : Deque a -> Bool
isEmpty deque =
    length deque == 0


member : a -> Deque a -> Bool
member item { front, rear } =
    List.member item front || List.member item rear


length : Deque a -> Int
length { rearLength, front } =
    rearLength + List.length front


reverse : Deque a -> Deque a
reverse { front, rear } =
    let
        ( rear_, rearLength ) =
            List.foldl
                (\item ( list, len ) -> ( item :: list, len + 1 ))
                ( [], 0 )
                front

        front_ =
            List.reverse rear
    in
        { front = front_
        , rear = rear_
        , rearLength = rearLength
        }


current : Deque a -> Maybe a
current { front } =
    List.head front


nth : Int -> Deque a -> Maybe a
nth index { rear, front, rearLength } =
    let
        pos =
            index - rearLength
    in
        if pos > 0 then
            let
                dropNum =
                    rearLength - (abs pos)
            in
                rear
                    |> List.drop dropNum
                    |> List.head
        else
            front
                |> List.drop (abs pos)
                |> List.head


rear : Deque a -> List a
rear { rear } =
    rear


front : Deque a -> List a
front { front } =
    front


clearRear : Deque a -> Deque a
clearRear ({ rear, front } as deque) =
    { deque | rear = [], rearLength = 0 }


clearFront : Deque a -> Deque a
clearFront ({ rear, front } as deque) =
    { deque | front = [] }


map : (a -> a) -> Deque a -> Deque a
map fun deque =
    deque


filter : (a -> Bool) -> Deque a -> Deque a
filter fun deque =
    deque


rollForward : Deque a -> Deque a
rollForward ({ front, rear, rearLength } as deque) =
    case List.head front of
        Just item ->
            let
                front_ =
                    front
                        |> List.tail
                        |> Maybe.withDefault ([])
            in
                { front = front_
                , rear = item :: rear
                , rearLength = rearLength + 1
                }

        Nothing ->
            deque


rollBackward : Deque a -> Deque a
rollBackward ({ front, rear, rearLength } as deque) =
    case List.head rear of
        Just item ->
            let
                rear_ =
                    rear
                        |> List.tail
                        |> Maybe.withDefault ([])
            in
                { front = item :: front
                , rear = rear_
                , rearLength = rearLength - 1
                }

        Nothing ->
            deque


cons : a -> Deque a -> Deque a
cons item ({ front } as deque) =
    { deque | front = item :: front }


drop : Deque a -> Deque a
drop deque =
    deque


indexedMap : (( a, Int ) -> a) -> Deque a -> Deque a
indexedMap fun list =
    indexedApply List.map fun list


toList : Deque a -> List a
toList { rear, front } =
    List.foldr (::) rear front


toIndexedList : Deque a -> List ( a, Int )
toIndexedList { rear, front } =
    let
        ( rear_, length ) =
            rear
                |> List.reverse
                |> withIndex 0

        ( front_, _ ) =
            withIndex length front
    in
        List.foldr (::) (List.reverse rear_) front_


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
    -> Deque a
    -> Deque c
indexedApply operation fun ({ rear, front } as list) =
    let
        ( revRear, rearLength ) =
            rear
                |> List.reverse
                |> withIndex 0

        ( revFront, _ ) =
            withIndex rearLength front

        rear_ =
            revRear
                |> operation fun
                |> List.reverse

        front_ =
            operation fun revFront
    in
        { front = front_, rear = rear_, rearLength = rearLength }
