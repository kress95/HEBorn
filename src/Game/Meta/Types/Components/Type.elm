module Game.Meta.Types.Components.Type exposing (..)

{-| Tipos de componentes e uma função para converter os tipos em `String`.
-}


{-| Tipos de componentes.
-}
type Type
    = CPU
    | HDD
    | RAM
    | NIC
    | USB
    | MOB


{-| Converte tipos de componentes em `String`.
-}
typeToString : Type -> String
typeToString type_ =
    case type_ of
        CPU ->
            "CPU"

        HDD ->
            "HDD"

        RAM ->
            "RAM"

        NIC ->
            "NIC"

        USB ->
            "USB"

        MOB ->
            "Motherboard"
