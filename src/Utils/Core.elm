module Utils.Core exposing (..)


update : (a -> msg) -> (b -> c) -> ( b, Cmd a ) -> ( c, Cmd msg )
update wrapper fun ( model, msg ) =
    ( fun model, Cmd.map wrapper msg )


subscriptions : a -> List (a -> Sub msg) -> Sub msg
subscriptions model =
    List.map (\fun -> fun model) >> Sub.batch
