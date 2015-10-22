module Main where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp
import Time exposing (Time)
import Easing exposing (ease, float)
import Window

import Routing exposing (Route)
import Common.Mailboxes exposing (pathChangeMailbox)
import Common.Types exposing (..)
import Common.Components


-- main

app: StartApp.App Model
app =
    let paths = Signal.map UpdateRoute Routing.currentRoute
        uis = Signal.map UpdateContext current
    in
        StartApp.start
            { init = init
            , view = view
            , update = update
            , inputs = [paths, uis]
            }

main: Signal Html
main =
    app.html


-- ports
port initialPath: String

port initialWidth: Int

port initialHeight: Int

port tasks : Signal (Task Never ())
port tasks = app.tasks

port runTask : Signal (Task error ())
port runTask = pathChangeMailbox.signal


-- model
type alias Model =
    { route: Routing.Route
    , context: Context
    , animation: Maybe AnimationState
    }


type Direction = Up | Down

type alias AnimationState =
    { prevClockTime : Time
    , elapsedTime: Time
    , nextRoute: Route
    , direction: Direction
    }

getContext: (Int, Int) -> Context
getContext (width, height) =
   { layout = if width < 1000 then Mobile else Desktop
   , width = width
   , height = height
   }

current: Signal Context
current =
    Window.dimensions
        |> Signal.map getContext




init: (Model, Effects Action)
init =
    let model =
        { route = Routing.getRoute initialPath
        , context = getContext (initialWidth, initialHeight)
        , animation = Nothing
        }
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Routing.Route
    | UpdateContext Context
    | StartAnimation Route Time
    | Tick Time


duration: Float
duration = Time.second*0.5


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateRoute route ->
            if route.url == model.route.url || not (model.animation == Nothing) then
                (model, Effects.none)
            else if route.view.fullScreen || model.route.view.fullScreen then
                ({ model | route <- route}, Effects.none)
            else
                (model, Effects.tick (StartAnimation route))

        UpdateContext context ->
            ({ model | context <- context }, Effects.none)

        StartAnimation route clockTime ->
            let direction = if route.sequence > model.route.sequence
                        then Down
                        else Up

                animation =
                    { prevClockTime = clockTime
                    , elapsedTime = 0
                    , nextRoute = route
                    , direction = direction
                    }
            in
                ({ model | animation <- Just animation }, Effects.tick Tick)

        Tick clockTime ->
            case model.animation of
                Nothing -> (model, Effects.none)
                Just animation ->
                    let newElapsedTime =
                        animation.elapsedTime + clockTime - animation.prevClockTime
                    in
                        if newElapsedTime > duration then
                            ( { model | route <- animation.nextRoute, animation <- Nothing }, Effects.none)
                        else
                            let animation' =
                                    { animation | elapsedTime <- newElapsedTime, prevClockTime <- clockTime }
                            in
                                ({ model | animation <- Just animation' }, Effects.tick Tick)


-- view
view : Signal.Address Action -> Model -> Html
view address model =
    let content =
            model.route.view.content model.context

        sidebar =
            if model.context.layout == Mobile || model.route.view.fullScreen then
                []
            else
                [Common.Components.sidebar model.route.url]

        renderContent margin url content' =
            let style' =
                if margin == 0 then [] else [("margin-top", toString margin ++ "px"), ("position", "fixed")]
            in
                div [ class "main-content", style style', key url ] content'
    in
        case model.animation of
            Nothing ->
                case model.context.layout of
                    Mobile ->
                        div [class "mobile" ] content

                    Desktop ->
                        div [ class "desktop" ]
                            (sidebar ++ [renderContent 0 model.route.url content])

            Just animation ->
                let nextContent =
                        animation.nextRoute.view.content model.context

                    alpha =
                        round <| ease Easing.easeInOutExpo float 0 (toFloat model.context.height) duration animation.elapsedTime

                    dir =
                        if animation.direction == Down then -1 else 1
                in
                    case model.context.layout of
                        Mobile ->
                            div [class "mobile" ] content

                        Desktop ->
                            div [ class "desktop" ]
                                (sidebar ++
                                    [ renderContent (dir * alpha) model.route.url content
                                    , renderContent (dir*(alpha - model.context.height)) animation.nextRoute.url nextContent
                                    ])

