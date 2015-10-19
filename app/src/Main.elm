module Main where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp
import Time exposing (Time)
import Easing exposing (ease, float)

import UI
import Routing exposing (Route)

-- main

app: StartApp.App Model
app =
    let
        paths = Signal.map UpdateRoute Routing.currentRoute
        uis = Signal.map UpdateLayout UI.current
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
port runTask = Routing.pathSignal


-- model
type alias Model =
    { route: Routing.Route
    , layout: UI.Layout
    , animation: Maybe AnimationState
    }


type Direction = Up | Down

type alias AnimationState =
    { prevClockTime : Time
    , elapsedTime: Time
    , nextRoute: Route
    , direction: Direction
    }


init: (Model, Effects Action)
init =
    let model =
        { route = Routing.getRoute initialPath
        , layout = UI.getLayout (initialWidth, initialHeight)
        , animation = Nothing
        }
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Routing.Route
    | UpdateLayout UI.Layout
    | StartAnimation Route Time
    | Tick Time


duration: Float
duration = Time.second*0.4


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateRoute route ->
            if route.url == model.route.url || not (model.animation == Nothing) then
                (model, Effects.none)
            else
                (model, Effects.tick (StartAnimation route))

        UpdateLayout layout ->
            ({ model | layout <- layout }, Effects.none)

        StartAnimation route clockTime ->
            let
                direction =
                    if route.sequence > model.route.sequence then
                        Down
                    else
                        Up

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
                            let
                                animation' =
                                    { animation | elapsedTime <- newElapsedTime, prevClockTime <- clockTime }
                            in
                                ({ model | animation <- Just animation' }, Effects.tick Tick)


-- view
sidebarWidth : Int
sidebarWidth = 240


view : Signal.Address Action -> Model -> Html
view address model =
    case model.layout of
        UI.Mobile ->
            div [] [ render model.layout model.route 0 ]

        UI.Desktop width height ->
            case model.animation of
                Nothing ->
                    div [] [ render model.layout model.route 0 ]

                Just animation ->
                    let
                        alpha =
                            ease Easing.easeInOutExpo float 0 1 duration animation.elapsedTime

                        marginTop =
                            round (alpha * (toFloat height))

                        dir =
                            case animation.direction of
                                Down -> -1
                                Up -> 1
                    in
                        div []
                            [ render model.layout model.route (dir*marginTop)
                            , render model.layout animation.nextRoute (dir*(marginTop - height))
                            ]

render: UI.Layout -> Route -> Int -> Html
render layout route marginTop =
    let
        style' =
            [("float", "right"), ("margin-top", toString marginTop ++ "px")]

        screen =
            UI.Context layout route.url Routing.pathAddress
                |> route.view
    in
        case screen.sidebar of
            Just sidebar ->
                div [ class "desktop", key route.url ]
                    [ sidebar
                    , div [ class "main-content", style style' ] screen.content
                    ]
            Nothing ->
                div [ class "mobile" ] screen.content


