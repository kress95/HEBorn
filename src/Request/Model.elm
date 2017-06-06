module Requests.Models exposing (..)

import Dict exposing (Dict)
import Uuid
import Random.Pcg as Random


type alias RequestID =
    String


type alias RequestStore a =
    Dict RequestID a


type alias Model request =
    { store : RequestStore request
    , seed : Seed
    }

empty : Model a
empty =
    { store = Dict.empty
    , seed = Random.initialSeed 42
    }

insert : a -> Model a -> Model a
insert 

get : RequestID -> Model a -> Maybe a
get id {store} =
    Dict.get id store

remove : a -> Model a -> Model a
remove : 