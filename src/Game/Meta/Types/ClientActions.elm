module Game.Meta.Types.ClientActions exposing (..)

{-| Ações do jogador observaveis que só são relevantes no client side.
-}


{-| Ações do jogador que só são relevantes no client side.
-}
type ClientActions
    = AccessedTaskManager
    | SpottedNastyVirus


{-| Converte uma ação em string.
-}
toString : ClientActions -> String
toString context =
    case context of
        AccessedTaskManager ->
            "tutorial_accessed_task_manager"

        SpottedNastyVirus ->
            "tutorial_spotted_nasty_virus"
