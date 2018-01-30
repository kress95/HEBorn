module OS.WindowManager.Update exposing (update)

import Draggable
import Draggable.Events as Draggable
import Utils.React as React exposing (React)
import OS.WindowManager.Config exposing (..)
import OS.WindowManager.Helpers exposing (..)
import OS.WindowManager.Messages exposing (..)
import OS.WindowManager.Models exposing (..)
import OS.WindowManager.Shared exposing (..)


type alias UpdateResponse msg =
    ( Model, React msg )


update : Config msg -> Msg -> Model -> UpdateResponse msg
update config msg model =
    case msg of
        NewApp app maybeContext maybeParams ->
            React.update model

        OpenApp context params ->
            React.update model

        PinWindow wId ->
            withSession config model <| pin wId >> React.update

        UnpinWindow wId ->
            withSession config model <| unpin wId >> React.update

        CloseWindow wId ->
            React.update <| close wId model

        -- window handling
        Minimize wId ->
            withSession config model <| minimize wId >> React.update

        ToggleVisibility wId ->
            withSession config model <| toggleVisibility wId >> React.update

        ToggleMaximize wId ->
            withWindow wId model <| toggleMaximize >> React.update

        SelectContext context wId ->
            withWindow wId model <| setContext context >> React.update

        UpdateFocus maybeWId ->
            withSession config model <| updateFocus maybeWId >> React.update

        -- drag messages
        StartDrag wId ->
            React.update <| startDragging wId (getSessionId config) model

        Dragging ( x, y ) ->
            onDragging x y model

        StopDrag ->
            React.update <| stopDragging model

        DragMsg msg ->
            onDragMsg config msg model

        -- dock messages
        ClickIcon app ->
            React.update model

        MinimizeAll app ->
            React.update model

        CloseAll app ->
            React.update model

        -- app messages
        BackFlixMsg appId msg ->
            React.update model

        BounceManagerMsg appId msg ->
            React.update model

        BrowserMsg appId msg ->
            React.update model

        BugMsg appId msg ->
            React.update model

        CalculatorMsg appId msg ->
            React.update model

        ConnManagerMsg appId msg ->
            React.update model

        DBAdminMsg appId msg ->
            React.update model

        EmailMsg appId msg ->
            React.update model

        ExplorerMsg appId msg ->
            React.update model

        FinanceMsg appId msg ->
            React.update model

        FloatingHeadsMsg appId msg ->
            React.update model

        HebampMsg appId msg ->
            React.update model

        LocationPickerMsg appId msg ->
            React.update model

        LogViewerMsg appId msg ->
            React.update model

        ServersGearsMsg appId msg ->
            React.update model

        TaskManagerMsg appId msg ->
            React.update model


withSession :
    Config msg
    -> Model
    -> (Session -> ( Session, React msg ))
    -> UpdateResponse msg
withSession config model map =
    let
        sessionId =
            getSessionId config
    in
        model
            |> getSession sessionId
            |> map
            |> Tuple.mapFirst (flip (insertSession sessionId) model)


withWindow :
    WindowId
    -> Model
    -> (Window -> ( Window, React msg ))
    -> UpdateResponse msg
withWindow windowId model map =
    let
        andMap ( window, react ) =
            ( insertWindow windowId window model, react )
    in
        model
            |> getWindow windowId
            |> Maybe.map (map >> andMap)
            |> Maybe.withDefault ( model, React.none )


onDragMsg : Config msg -> Draggable.Msg WindowId -> Model -> UpdateResponse msg
onDragMsg config msg model =
    let
        dragConfig =
            Draggable.customConfig
                [ Draggable.onDragBy (Dragging >> config.toMsg)
                , Draggable.onDragStart (StartDrag >> config.toMsg)
                , Draggable.onDragEnd (config.toMsg StopDrag)
                ]
    in
        model
            |> Draggable.update dragConfig msg
            |> Tuple.mapSecond React.cmd


onDragging : Float -> Float -> Model -> UpdateResponse msg
onDragging x y model =
    case getDragging model of
        Just windowId ->
            withWindow windowId model (move x y >> React.update)

        Nothing ->
            React.update model



--updateApp : Config msg ->
