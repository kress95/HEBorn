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
        , focusNth
        , removeNth
        , current
        , getRear
        , getFront
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
        , consAside
        , drop
        , replace
          --
        , indexedMap
        )

{-
   This data structure is named deque, but it's not really a deque, it's more
   like a slider list.

   While this data structure is kinda fast (still some room for improvements),
   it's not mature and will need to be moved out of this codebase as it would
   be easier to maintain it as a UX data structure library.
-}

import Utils exposing (andJust)
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
isEmpty { rear, front } =
    List.isEmpty rear && List.isEmpty front


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


focusNth : Int -> Deque a -> Deque a
focusNth index ({ rear, front, rearLength } as deque) =
    if index == rearLength then
        deque
    else
        let
            diff =
                index - rearLength

            direction =
                if diff > 0 then
                    rollForward
                else
                    rollBackward

            reduce =
                \acc n ->
                    if n > 0 then
                        reduce (direction acc) (n - 1)
                    else
                        acc
        in
            reduce deque (abs diff)


removeNth : Int -> Deque a -> Deque a
removeNth index ({ rear, front, rearLength } as deque) =
    let
        diff =
            index - rearLength

        n =
            abs diff
    in
        if index == rearLength then
            drop deque
        else if diff > 0 && n <= (List.length front) then
            -- TODO: cache frontLength to make this faster
            { deque | front = dropNth n front }
        else if diff < 0 && n <= rearLength then
            { deque | rear = dropNth n rear, rearLength = rearLength - 1 }
        else
            deque


getRear : Deque a -> List a
getRear { rear } =
    rear


getFront : Deque a -> List a
getFront { front } =
    front
        |> List.tail
        |> Maybe.withDefault []


clearRear : Deque a -> Deque a
clearRear ({ rear, front } as deque) =
    { deque | rear = [], rearLength = 0 }


clearFront : Deque a -> Deque a
clearFront ({ rear, front } as deque) =
    let
        front_ =
            front
                |> List.head
                |> andJust List.singleton
                |> Maybe.withDefault []
    in
        { deque | front = front_ }


map : (a -> a) -> Deque a -> Deque a
map fun deque =
    deque


filter : (a -> Bool) -> Deque a -> Deque a
filter fun deque =
    deque


rollForward : Deque a -> Deque a
rollForward ({ rear, front, rearLength } as deque) =
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
rollBackward ({ rear, front, rearLength } as deque) =
    case List.head rear of
        Just item ->
            let
                rear_ =
                    rear
                        |> List.tail
                        |> Maybe.withDefault []
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


consAside : a -> Deque a -> Deque a
consAside newItem ({ front, rear, rearLength } as deque) =
    -- TODO: rename to consRoll
    case List.head front of
        Just oldItem ->
            let
                front_ =
                    front
                        |> List.tail
                        |> Maybe.withDefault []
            in
                { deque
                    | front = newItem :: front_
                    , rear = oldItem :: rear
                    , rearLength = rearLength + 1
                }

        Nothing ->
            cons newItem deque


replace : a -> Deque a -> Deque a
replace item ({ front } as deque) =
    case List.tail front of
        Just front_ ->
            { deque | front = item :: front_ }

        Nothing ->
            { deque | front = [ item ] }


drop : Deque a -> Deque a
drop ({ rear, front, rearLength } as deque) =
    let
        front_ =
            front
                |> List.tail
                |> Maybe.withDefault []
    in
        if List.isEmpty front_ then
            case List.head rear of
                Just item ->
                    let
                        rear_ =
                            rear
                                |> List.tail
                                |> Maybe.withDefault []
                    in
                        { deque
                            | front = [ item ]
                            , rear = rear_
                            , rearLength = rearLength - 1
                        }

                Nothing ->
                    { deque | front = front_ }
        else
            { deque | front = front_ }


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



-- private


dropNth : Int -> List a -> List a
dropNth n list =
    let
        left =
            List.take n list

        right =
            list
                |> List.drop n
                |> List.tail
                |> Maybe.withDefault []
    in
        left ++ right


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
