module OS.WindowManager.Models exposing (..)

import Dict exposing (Dict)
import Draggable
import Random.Pcg as Random
import Uuid
import Utils.Maybe as Maybe
import Apps.Models as Apps
import Game.Meta.Types.Apps.Desktop as Desktop
import Game.Meta.Types.Context exposing (Context(..))
import Game.Servers.Shared exposing (CId)
import OS.WindowManager.Shared exposing (..)


type alias Model =
    { apps : Apps
    , windows : Windows
    , sessions : Sessions
    , dragging : Maybe WindowId
    , lastPosition : Position
    , seed : Random.Seed
    , drag : Draggable.State WindowId
    }



-- apps


type alias Apps =
    Dict AppId App


type alias App =
    { windowId : WindowId
    , serverCId : CId
    , model : Apps.AppModel
    }



-- windows


type alias Windows =
    Dict WindowId Window


type alias Window =
    { position : Position
    , size : Size
    , maximized : IsMaximized
    , decorated : IsDecorated
    , instance : Instance
    , originSessionId : SessionId
    }


type alias Position =
    { x : Float
    , y : Float
    }


type alias Size =
    { width : Float
    , height : Float
    }


type alias IsMaximized =
    Bool


type alias IsDecorated =
    Bool


type Instance
    = Single Context AppId
    | Double Context AppId (Maybe AppId)



-- sessions


type alias Sessions =
    Dict SessionId Session


type alias Session =
    { hidden : Index
    , visible : Index
    , focusing : Maybe WindowId
    }


type alias Index =
    List WindowId



-- initializers


initialModel : Model
initialModel =
    { apps = Dict.empty
    , windows = Dict.empty
    , sessions = Dict.empty
    , dragging = Nothing
    , lastPosition = Position 0 44
    , seed = Random.initialSeed 844121764423
    , drag = Draggable.init
    }


initialSession : Session
initialSession =
    { hidden = []
    , visible = []
    , focusing = Nothing
    }



-- integrations


getApp : AppId -> Model -> Maybe App
getApp appId =
    .apps >> Dict.get appId


getWindow : WindowId -> Model -> Maybe Window
getWindow windowId =
    .windows >> Dict.get windowId


getSession : SessionId -> Model -> Session
getSession sessionId model =
    case Dict.get sessionId model.sessions of
        Just session ->
            session

        Nothing ->
            initialSession


getDragging : Model -> Maybe WindowId
getDragging =
    .dragging


newAppId : Model -> ( Model, AppId )
newAppId =
    getUuid


newWindowId : Model -> ( Model, WindowId )
newWindowId =
    getUuid


insert : Window -> App -> Maybe App -> Model -> Model
insert window app maybeApp model =
    let
        sessionId =
            window.originSessionId

        { windowId } =
            app

        session =
            model
                |> getSession window.originSessionId
                |> updateFocus (Just app.windowId)

        -- this part is a bit hairy, there's that strange case of apps not
        -- having an endpoint session yet due to not being connected
        ( appId, maybeAppId ) =
            case window.instance of
                Single _ appId ->
                    ( appId, Nothing )

                Double _ appId maybeAppId ->
                    ( appId, maybeAppId )

        model_ =
            case Maybe.uncurry maybeAppId maybeApp of
                Just ( appId, app ) ->
                    insertApp appId app model

                Nothing ->
                    model
    in
        model_
            |> insertApp appId app
            |> insertWindow windowId window
            |> insertSession sessionId session


insertWindow : WindowId -> Window -> Model -> Model
insertWindow windowId window model =
    -- this is a dumb function use it to update existing windows
    { model | windows = Dict.insert windowId window model.windows }


insertApp : AppId -> App -> Model -> Model
insertApp appId app model =
    -- this is a dumb function use it to update existing apps
    { model | apps = Dict.insert appId app model.apps }


insertSession : SessionId -> Session -> Model -> Model
insertSession sessionId session model =
    -- this is a dumb function use it to update existing sessions
    { model | sessions = Dict.insert sessionId session model.sessions }


removeApp : AppId -> Model -> Model
removeApp appId model =
    { model | apps = Dict.remove appId model.apps }


close : WindowId -> Model -> Model
close windowId model =
    let
        killAppsFast { instance } =
            case instance of
                Single _ appId ->
                    removeApp appId model

                Double _ appId1 (Just appId2) ->
                    model
                        |> removeApp appId1
                        |> removeApp appId2

                Double _ appId _ ->
                    removeApp appId model

        killAppsSlow () =
            -- this code may not need to exist
            let
                apps =
                    Dict.filter (\_ app -> app.windowId /= windowId) model.apps
            in
                { model | apps = apps }

        model_ =
            case getWindow windowId model of
                Just window ->
                    killAppsFast window

                Nothing ->
                    killAppsSlow ()

        sessions =
            -- this is slow, it's a bottleneck of pinned windows
            Dict.map (\_ session -> unpin windowId session) model_.sessions
    in
        { model_ | sessions = sessions }



-- app helpers


getModel : App -> Apps.AppModel
getModel =
    .model


setModel : Apps.AppModel -> App -> App
setModel appModel app =
    { app | model = appModel }


getWindowId : App -> WindowId
getWindowId =
    .windowId


getServerCId : App -> CId
getServerCId =
    .serverCId



-- window helpers


getPosition : Window -> Position
getPosition =
    .position


getSize : Window -> Size
getSize =
    .size


getContext : Window -> Context
getContext { instance } =
    case instance of
        Single context _ ->
            context

        Double context _ _ ->
            context


getActiveAppId : Window -> AppId
getActiveAppId window =
    case window.instance of
        Single _ appId ->
            appId

        Double Gateway appId maybeAppId ->
            appId

        Double Endpoint _ (Just appId) ->
            appId

        Double Endpoint _ Nothing ->
            Debug.crash "Impossible window state"


setContext : Context -> Window -> Window
setContext context window =
    case window.instance of
        Single _ _ ->
            window

        Double _ appId maybeAppId ->
            { window | instance = Double context appId maybeAppId }


hasMultipleContext : Window -> Bool
hasMultipleContext window =
    case window.instance of
        Single _ _ ->
            False

        Double _ _ Nothing ->
            False

        Double _ _ _ ->
            True


isMaximized : Window -> Bool
isMaximized =
    .maximized


hasDecoration : Window -> Bool
hasDecoration =
    .decorated


isSession : SessionId -> Window -> Bool
isSession sessionId { originSessionId } =
    sessionId == originSessionId


toggleMaximize : Window -> Window
toggleMaximize window =
    { window | maximized = not window.maximized }


toggleContext : Window -> Window
toggleContext window =
    case window.instance of
        Single _ _ ->
            window

        Double Gateway _ _ ->
            setContext Endpoint window

        Double Endpoint _ _ ->
            setContext Gateway window


move : Float -> Float -> Window -> Window
move deltaX deltaY ({ position } as window) =
    let
        position_ =
            Position (position.x + deltaX) (position.y + deltaY)
    in
        { window | position = position_ }



-- session helpers


pin : WindowId -> Session -> Session
pin =
    restore


unpin : WindowId -> Session -> Session
unpin windowId session =
    let
        filterer =
            (/=) >> List.filter

        visible =
            filterer windowId session.visible

        hidden =
            filterer windowId session.hidden
    in
        { session
            | visible = visible
            , hidden = hidden
            , focusing = List.head <| List.reverse visible
        }


minimize : WindowId -> Session -> Session
minimize windowId session =
    let
        filterer =
            (/=) >> List.filter

        visible =
            filterer windowId session.visible

        hidden =
            session.hidden
                |> filterer windowId
                |> (::) windowId
    in
        { session
            | visible = visible
            , hidden = hidden
            , focusing = List.head <| List.reverse visible
        }


restore : WindowId -> Session -> Session
restore windowId session =
    let
        filterer =
            (/=) >> List.filter

        visible =
            session.visible
                |> filterer windowId
                |> List.reverse
                |> (::) windowId
                |> List.reverse

        hidden =
            filterer windowId session.hidden
    in
        { session
            | visible = visible
            , hidden = hidden
            , focusing = Just windowId
        }


toggleVisibility : WindowId -> Session -> Session
toggleVisibility windowId session =
    if List.member windowId session.visible then
        minimize windowId session
    else
        restore windowId session


updateFocus : Maybe WindowId -> Session -> Session
updateFocus maybeWindowId session =
    case maybeWindowId of
        Just windowId ->
            restore windowId session

        Nothing ->
            { session | focusing = Nothing }



-- middleware


startDragging : WindowId -> SessionId -> Model -> Model
startDragging windowId sessionId model =
    let
        model_ =
            { model | dragging = Just windowId }

        session =
            model_
                |> getSession sessionId
                |> updateFocus (Just windowId)
    in
        insertSession sessionId session model_


stopDragging : Model -> Model
stopDragging model =
    { model | dragging = Nothing }



-- misc
---- internals


getUuid : Model -> ( Model, String )
getUuid model =
    let
        ( uuid, seed ) =
            Random.step Uuid.uuidGenerator model.seed
    in
        ( { model | seed = seed }, Uuid.toString uuid )
