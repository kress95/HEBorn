module Apps.Explorer.ModelTest exposing (all)

import Expect
import Test exposing (Test, describe)
import Fuzz exposing (int, tuple)
import TestUtils exposing (fuzz, once, ensureDifferentSeed)
import Gen.Game
import Gen.Servers
import Gen.Filesystem
import Gen.Explorer as Gen
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
    [ once Playstate.one "can move to an existing folder" <|
        \play ->
            let
                explorer0 =
                    initialExplorer

                ( game, server, folder ) =
                    ( play.game, play.server, play.valid.folder )

                explorer =
                    { explorer0 | serverID = (getServerIDSafe server) }

                explorer_ =
                    changePath explorer game (getFilePath folder)
            in
                Expect.equal (getPath explorer_) (getFilePath folder)
    , fuzz
        (tuple ( Playstate.one, Gen.Filesystem.path ))
        "cant move to a non-existing folder"
      <|
        \( play, path ) ->
            let
                explorer =
                    initialExplorer

                game =
                    play.game

                explorer_ =
                    changePath explorer game path
            in
                Expect.equal explorer explorer_
    ]
