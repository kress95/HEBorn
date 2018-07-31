module Game.Account.Bounces.Shared exposing (..)

{-| Tipos utilizados remotamente.
-}


{-| Id de uma `Bounce`.
-}
type alias ID =
    String


{-| Erros que podem ocorrer ao criar um `Bounce`.
-}
type CreateError
    = CreateBadRequest
    | CreateFailed
    | CreateUnknown


{-| Erros que podem ocorrer ao atualizar um `Bounce`.
-}
type UpdateError
    = UpdateBadRequest
    | UpdateFailed
    | UpdateUnknown


{-| Erros que podem ocorrer ao remover um `Bounce`.
-}
type RemoveError
    = RemoveBadRequest
    | RemoveUnknown
