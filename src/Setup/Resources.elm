module Setup.Resources exposing (..)


type Class
    = StepWelcome
    | StepPickLocation
    | StepHostname
    | StepChooseTheme
    | StepFinish
    | Selected
    | NextPageButton
    | PreviousPageButton
    | MainframeNameField


prefix : String
prefix =
    "setup"


setupNode : String
setupNode =
    prefix ++ "Wiz"


leftBarNode : String
leftBarNode =
    prefix ++ "Steps"


contentNode : String
contentNode =
    prefix ++ "Main"
