module Game.Storyline.Messages exposing (Msg(..))

import Game.Storyline.Missions.Messages as Missions
import Game.Storyline.Emails.Messages as Emails


type Msg
    = MissionsMsg Missions.Msg
    | EmailsMsg Emails.Msg
