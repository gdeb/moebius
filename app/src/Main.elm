module Main where

import Html exposing (..)
import Html.Attributes exposing (class, style)
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
duration = Time.second*0.5


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
    case model.animation of
        Nothing ->
            div [] [
            UI.Context model.layout model.route.url Routing.pathAddress
                |> model.route.view
                |> UI.render
                ]
        Just animation ->
            let
                currentScreen =
                    UI.Context model.layout model.route.url Routing.pathAddress
                        |> model.route.view

                nextScreen =
                    UI.Context model.layout animation.nextRoute.url Routing.pathAddress
                        |> animation.nextRoute.view

                alpha =
                    ease Easing.easeOutExpo float 0 1 duration animation.elapsedTime
                leftOffset w =
                    round (240 + alpha * (toFloat w - 240))

                marginTop h =
                    round (alpha * (toFloat h))
            in
                case model.layout of
                    UI.Mobile ->
                        div [] [ text "hmmmm" ]
                    UI.Desktop width height ->
                        case animation.direction of
                            Down ->
                                div []
                                    [ render (-(marginTop height)) currentScreen
                                    , div [ class "desktop", style [("position", "fixed"), ("top", "0px")]]
                                        [ div [class "main-content", style [("margin-left", toString sidebarWidth ++ "px"), ("margin-top",toString (height - (marginTop height)) ++ "px"), ("display", "flex")]] nextScreen.content ]
                                    ]
                            Up ->
                                div []
                                    [ render (marginTop height) currentScreen
                                    , div [ class "desktop", style [("position", "fixed"), ("top", "0px")]]
                                        [ div [class "main-content", style [("margin-left", toString sidebarWidth ++ "px"), ("margin-top",toString ((marginTop height) - height) ++ "px"), ("display", "flex")]] nextScreen.content ]
                                    ]


render: Int -> UI.Screen -> Html
render marginTop screen =
    case screen.sidebar of
        Just sidebar ->
            div [ class "desktop" ]
                [ sidebar
                , div [ class "main-content", style [("float", "right"), ("margin-top", toString marginTop ++ "px")] ] screen.content
                ]
        Nothing ->
            div [ class "mobile" ] screen.content


