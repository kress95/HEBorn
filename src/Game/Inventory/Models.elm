module Game.Inventory.Models exposing (..)

{-| Inventário contém itens pertencentes ao jogador.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Components as Components exposing (Components)
import Game.Meta.Types.Components.Type as Components
import Game.Meta.Types.Components.Specs as Specs exposing (Specs)
import Game.Meta.Types.Network.Connections as NetConnections exposing (Connections)
import Game.Inventory.Shared exposing (..)


{-| A model contém componentes, conexões de rede e as especificações de
componentes.
-}
type alias Model =
    { components : Components
    , ncs : Connections
    , specs : Specs
    }


{-| Model inicial do inventário.
-}
initialModel : Model
initialModel =
    { components = Components.empty
    , ncs = NetConnections.empty
    , specs = Specs.empty
    }


{-| Retorna `Specs`.
-}
getSpecs : Model -> Specs
getSpecs =
    .specs


{-| Tenta encontrar `Component` na `Model`.
-}
getComponent : Components.Id -> Model -> Maybe Components.Component
getComponent id model =
    Components.get id model.components


{-| Insere `Component` na `Model`.
-}
insertComponent : Components.Id -> Components.Component -> Model -> Model
insertComponent id component model =
    let
        components =
            Components.insert id component model.components
    in
        { model | components = components }


{-| Remove `Component` da `Model`.
-}
removeComponent : Components.Id -> Model -> Model
removeComponent id model =
    let
        components =
            Components.remove id model.components
    in
        { model | components = components }


{-| Tenta encontrar `Connection` na `Model`.
-}
getNC : NetConnections.Id -> Model -> Maybe NetConnections.Connection
getNC id model =
    NetConnections.get id model.ncs


{-| Insere `Connection` na `Model.
-}
insertNC : NetConnections.Id -> NetConnections.Connection -> Model -> Model
insertNC id connection model =
    let
        ncs =
            NetConnections.insert id connection model.ncs
    in
        { model | ncs = ncs }


{-| Remove `Connection` da `Model.
-}
removeNC : NetConnections.Id -> Model -> Model
removeNC id model =
    let
        ncs =
            NetConnections.remove id model.ncs
    in
        { model | ncs = ncs }


{-| Atualiza disponibilidade da `Entry`.
-}
setAvailability : Bool -> Entry -> Model -> Model
setAvailability available entry model =
    case entry of
        Component id ->
            case getComponent id model of
                Just component ->
                    insertComponent id
                        (Components.setAvailable False component)
                        model

                Nothing ->
                    model

        NetConnection id ->
            case getNC id model of
                Just connection ->
                    insertNC id
                        (NetConnections.setAvailable False connection)
                        model

                Nothing ->
                    model


{-| Retorna disponibilidade da `Entry`.
-}
isAvailable : Entry -> Model -> Maybe Bool
isAvailable entry model =
    case entry of
        Component id ->
            model
                |> getComponent id
                |> Maybe.map Components.isAvailable

        NetConnection id ->
            model
                |> getNC id
                |> Maybe.map NetConnections.isAvailable


{-| Agrupa inventário por tipo de componente e disponibilidade, o primeiro item
da tupla contém componentes disponíveis, o segundo contém componentes já
utilizados.
-}
group : (Entry -> Bool) -> Model -> Groups
group isAvailable model =
    let
        groupBy =
            groupHelper isAvailable

        reduceComponents id component group =
            groupBy (Components.typeToString <| Components.getType component)
                (Component id)
                group

        reduceConnections id _ group =
            groupBy "Network Connections" (NetConnection id) group

        appendFold func =
            flip <| Dict.foldl func
    in
        model.components
            |> Dict.foldl reduceComponents Dict.empty
            |> appendFold reduceConnections model.ncs



-- funções internas


{-| Retorna um reducer.
-}
groupHelper :
    (Entry -> Bool)
    -> String
    -> Entry
    -> Groups
    -> Groups
groupHelper isAvailable key entry groups =
    let
        ( free, using ) =
            groups
                |> Dict.get key
                |> Maybe.withDefault ( [], [] )

        value =
            -- agrupa entry de acordo com disponibilidade
            if isAvailable entry then
                ( entry :: free, using )
            else
                ( free, entry :: using )
    in
        Dict.insert key value groups
