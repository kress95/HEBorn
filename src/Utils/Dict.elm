module Utils.Dict exposing (safeUpdate)

import Dict exposing (Dict)


safeUpdate :
    comparable
    -> a
    -> Dict comparable a
    -> Dict comparable a
safeUpdate key value dict =
    let
        fnUpdate item =
            case item of
                Just _ ->
                    Just value

                Nothing ->
                    Nothing
    in
        Dict.update key fnUpdate dict
