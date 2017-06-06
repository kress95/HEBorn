module Requests.Code exposing (RequestCode(..), fromInt)


type RequestCode
    = RequestCodeOk
    | RequestCodeNotFound
    | RequestCodeUnknownError


fromInt : Int -> RequestCode
fromInt httpCode =
    case httpCode of
        200 ->
            RequestCodeOk

        404 ->
            RequestCodeNotFound

        _ ->
            RequestCodeUnknownError
