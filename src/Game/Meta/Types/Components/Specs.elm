module Game.Meta.Types.Components.Specs exposing (..)

{-| Especificações de componentes.
-}

import Dict exposing (Dict)
import Game.Meta.Types.Components.Type as Components


-- NOTA: component type deve virar slot type no futuro!


{-| Id da especificação
-}
type alias Id =
    String


{-| `Dict` com todas as especificações.
-}
type alias Specs =
    Dict Id Spec


{-| Especificação, contém nome do componente, descrição e metadados.
-}
type alias Spec =
    { name : String
    , description : String
    , meta : Meta
    }


{-| Metadados de um tipo de componente.
-}
type Meta
    = CPU MetaCPU
    | HDD MetaHDD
    | RAM MetaRAM
    | NIC MetaNIC
    | USB MetaUSB
    | MOB MetaMOB


{-| Metadados de processador:

  - `clock`

Velocidade de clock do processador.

-}
type alias MetaCPU =
    { clock : Int }


{-| Metadados de disco rídigo:

  - `size`

Espaço do disco.

  - `iops`

Velocidade do disco.

-}
type alias MetaHDD =
    { size : Int
    , iops : Int
    }


{-| Metadados para memória RAM:

  - `size`

Quantidade de RAM.

  - `frequency`

Frequência da memória RAM.

-}
type alias MetaRAM =
    { size : Int
    , frequency : Int
    }


{-| Metadados para NIC.
-}
type alias MetaNIC =
    { uplink : Int
    , downlink : Int
    }


{-| Metadados para dispositivos USB.
-}
type alias MetaUSB =
    { size : Int }


{-| Metadados para placa mãe.
-}
type alias MetaMOB =
    { cpu : Int
    , hdd : Int
    , ram : Int
    , nic : Int
    , usb : Int
    }


{-| Especificações iniciais.
-}
empty : Specs
empty =
    -- especificações temporariamente hardcoded
    Dict.fromList
        [ ( "cpu_001", Spec "Threadisaster" "" <| CPU <| MetaCPU 256 )
        , ( "ram_001", Spec "Ram Na Montana" "" <| RAM <| MetaRAM 256 100 )
        , ( "hdd_001", Spec "SemDisk" "" <| HDD <| MetaHDD 1024 1000 )
        , ( "nic_001", Spec "BoringNic" "" <| NIC <| MetaNIC 0 0 )
        , ( "mobo_001", Spec "Mobo1" "" <| MOB <| MetaMOB 1 1 1 1 0 )
        , ( "mobo_002", Spec "Mobo2" "" <| MOB <| MetaMOB 2 1 2 1 1 )
        , ( "mobo_999", Spec "Mobo9" "" <| MOB <| MetaMOB 4 4 4 4 4 )
        ]


{-| Renderiza especificação.
-}
render : Spec -> List ( String, String )
render spec =
    case spec.meta of
        CPU { clock } ->
            [ ( "clock", toString clock ) ]

        HDD { size, iops } ->
            [ ( "size", toString size )
            , ( "iops", toString iops )
            ]

        RAM { size, frequency } ->
            [ ( "size", toString size )
            , ( "frequency", toString frequency )
            ]

        NIC { uplink, downlink } ->
            [ ( "uplink", toString uplink )
            , ( "downlink", toString downlink )
            ]

        USB { size } ->
            [ ( "size", toString size ) ]

        MOB { cpu, hdd, ram, nic, usb } ->
            [ ( "cpu", toString cpu )
            , ( "hdd", toString hdd )
            , ( "ram", toString ram )
            , ( "nic", toString nic )
            , ( "usb", toString usb )
            ]


{-| Tenta pegar especificação.
-}
get : Id -> Specs -> Maybe Spec
get =
    Dict.get


{-| Retorna nome da especificação.
-}
getName : Spec -> String
getName =
    .name


{-| Retorna descrição da especificação.
-}
getDescription : Spec -> String
getDescription =
    .description


{-| Retorna tipo de componente da especificação.
-}
toType : Spec -> Components.Type
toType { meta } =
    case meta of
        CPU _ ->
            Components.CPU

        HDD _ ->
            Components.HDD

        RAM _ ->
            Components.RAM

        NIC _ ->
            Components.NIC

        USB _ ->
            Components.USB

        MOB _ ->
            Components.MOB
