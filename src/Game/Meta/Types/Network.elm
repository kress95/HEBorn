module Game.Meta.Types.Network exposing (..)

{-| Tipos relacionados a networks.
-}


{-| Endereço de `IP`.
-}
type alias IP =
    String


{-| `ID` de uma rede.
-}
type alias ID =
    String


{-| Tupla contendo `ID` da rede e o endereço de `IP`.
-}
type alias NIP =
    ( ID, IP )


{-| `NIP` convertido para String.
-}
type alias StringifiedNIP =
    String


{-| `NIP` convertido para String.
-}
toNip : ID -> IP -> NIP
toNip =
    (,)


{-| Retorna `ID` de um `NIP`.
-}
getId : NIP -> ID
getId =
    Tuple.first


{-| Retorna `IP` de um `NIP`.
-}
getIp : NIP -> IP
getIp =
    Tuple.second


{-| Converte `NIP` em `String`.
-}
toString : NIP -> StringifiedNIP
toString ( id, ip ) =
    id ++ "," ++ ip


{-| Converte `StringifiedNIP` em `NIP`.
-}
fromString : StringifiedNIP -> NIP
fromString str =
    case String.split "," str of
        [ id, ip ] ->
            ( id, ip )

        _ ->
            ( "::", "" )


{-| Verifica se um `NIP` pertence a internet pública.
-}
isFromInternet : NIP -> Bool
isFromInternet ( id, _ ) =
    id == "::"


{-| Filtra uma lista de `NIP` mantendo somente os que pertencerem a internet.
-}
filterInternet : List NIP -> List NIP
filterInternet list =
    List.filter isFromInternet list


{-| Converte `NIP` em uma `String` que deve ser utilizada somente para fins
de representação visual.
-}
render : NIP -> String
render nip =
    Tuple.second nip
