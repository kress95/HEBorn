module OS.Models exposing (Model, initialModel)

import OS.SessionManager.WindowManager.Models
import OS.Header.Models
import OS.Dock.Models
import OS.Menu.Models


type alias Model =
    { wm : OS.SessionManager.WindowManager.Models.Model
    , header : OS.Header.Models.Model
    , dock : OS.Dock.Models.Model
    , context : OS.Menu.Models.Model
    }


initialModel : Model
initialModel =
    { wm = OS.SessionManager.WindowManager.Models.initialModel
    , header = OS.Header.Models.initialModel
    , dock = OS.Dock.Models.initialModel
    , context = OS.Menu.Models.initialContext
    }
