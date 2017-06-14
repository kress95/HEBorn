module Landing.SignUp.Requests.SignUp
    exposing
        ( Response(..)
        , Errors
        , request
        , receive
        )

import Json.Decode as Decode exposing (Decoder, Value, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Encode as Encode
import Core.Config exposing (Config)
import Landing.SignUp.Messages exposing (..)
import Requests.Requests as Requests
import Requests.Topics exposing (Topic(..))
import Requests.Types exposing (Code(..))


type Response
    = OkResponse String String String
    | ErrorResponse Errors
    | NoOp


type alias Errors =
    { email : List String
    , username : List String
    , password : List String
    }


request : String -> String -> String -> Config -> Cmd Msg
request email username password =
    Requests.request AccountCreateTopic
        (SignUpRequest >> Request)
        Nothing
        (encoder email username password)


receive : Code -> String -> Response
receive code json =
    case code of
        OkCode ->
            Requests.report (decodeString decoderOk json)

        BadRequestCode ->
            json
                |> decodeString decoderError
                |> Result.map ErrorResponse
                |> Requests.report

        _ ->
            NoOp



-- internals


encoder : String -> String -> String -> Encode.Value
encoder email username password =
    Encode.object
        [ ( "email", Encode.string email )
        , ( "username", Encode.string username )
        , ( "password", Encode.string password )
        ]


decoderOk : Decoder Response
decoderOk =
    decode OkResponse
        |> required "email" Decode.string
        |> required "username" Decode.string
        |> required "account_id" Decode.string


decoderError : Decoder Errors
decoderError =
    decode Errors
        |> required "email" (Decode.list Decode.string)
        |> required "username" (Decode.list Decode.string)
        |> required "password" (Decode.list Decode.string)
