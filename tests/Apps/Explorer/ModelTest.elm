module Apps.Explorer.ModelTest exposing (all)

import Expect
import Utils exposing (swap)
import Test exposing (Test, describe)
import Fuzz exposing (tuple)
import TestUtils exposing (fuzz, once)
import Gen.Filesystem
import Helper.Playstate as Playstate
import Game.Servers.Models as Server exposing (..)
import Game.Servers.Filesystem.Models as Filesystem exposing (..)
import Apps.Explorer.Models as Explorer exposing (..)


all : Test
all =
    describe "explorer"
        [ pathOperations
        ]


pathOperations : Test
pathOperations =
    describe "path operations"
        [ describe "move around"
            pathMoveAroundTests
        ]



--------------------------------------------------------------------------------
-- Move around
--------------------------------------------------------------------------------


pathMoveAroundTests : List Test
pathMoveAroundTests =
    [ once
        Playstate.one
        "can move to an existing folder"
      <|
        \{ game, server, valid } ->
            let
                { folder } =
                    valid

                -- this function could be added to the model
                changeServer =
                    (\id explorer -> { explorer | serverID = id })

                explorer =
                    initialExplorer
                        |> changeServer (getServerIDSafe server)
                        |> (swap changePath) (getFilePath folder) game
            in
                folder
                    |> getFilePath
                    |> Expect.equal (getPath explorer)
    , fuzz
        (tuple ( Playstate.one, Gen.Filesystem.path ))
        "can't move to a non-existing folder"
      <|
        \( { game }, path ) ->
            initialExplorer
                |> (swap changePath) path game
                |> Expect.equal initialExplorer
    ]
