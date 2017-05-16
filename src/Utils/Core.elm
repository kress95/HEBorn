module Utils.Core exposing (..)


update : (a -> msg) -> (b -> c) -> ( b, Cmd a ) -> ( c, Cmd msg )
update wrapper fun ( model, msg ) =
    ( fun model, Cmd.map wrapper msg )


subscriptions : b -> List ( b -> Sub a, a -> msg ) -> Sub msg
subscriptions model =
    List.map (\( fun, msg ) -> model |> fun |> Sub.map msg) >> Sub.batch
