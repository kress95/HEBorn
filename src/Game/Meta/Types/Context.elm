module Game.Meta.Types.Context exposing (..)

{-| Contexto do servidor afetado pelo aplicativo ou sessão.
-}


{-| Tipos de contexto utilizados por aplicativos e sessões, pode ser `Gateway`
para um servidor que o jogador seja dono ou `Endpoint` para computadores
acessados remotamente.
-}
type Context
    = Gateway
    | Endpoint


{-| Converte `Context` em `String`.
-}
toString : Context -> String
toString context =
    case context of
        Gateway ->
            "Gateway"

        Endpoint ->
            "Endpoint"
