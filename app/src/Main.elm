module Main where

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp
import Time exposing (Time)
import Easing exposing (ease, easeOutBounce, float)

import UI
import Routing

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

port tasks : Signal (Task Never ())
port tasks = app.tasks

port runTask : Signal (Task error ())
port runTask = Routing.pathSignal


-- model
type alias Model =
    { route: Routing.Route
    , nextRoute: Maybe Routing.Route
    , layout: UI.Layout
    , animation: AnimationState
    }


type alias AnimationState =
    Maybe { prevClockTime : Time
          , elapsedTime: Time
          }


init: (Model, Effects Action)
init =
    let model =
        Model (Routing.getRoute initialPath) Nothing (UI.getLayout initialWidth) Nothing
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Routing.Route
    | UpdateLayout UI.Layout
    | Tick Time


duration: Float
duration = Time.second*0.8


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateRoute route ->
            let
                model' = { model | nextRoute <- Just route }
            in
                if route.url == model.route.url || not (model.animation == Nothing) then
                    (model, Effects.none)
                else
                    (model', Effects.tick Tick)

        UpdateLayout layout ->
            ({ model | layout <- layout }, Effects.none)

        Tick clockTime ->
            let
                nextRoute =
                    case model.nextRoute of
                        Just r -> r
                        Nothing -> model.route

                newElapsedTime =
                    case model.animation of
                        Nothing -> 0
                        Just {elapsedTime, prevClockTime} ->
                              elapsedTime + (clockTime - prevClockTime)
            in
                if newElapsedTime > duration then
                    ( { model | route <- nextRoute
                        , nextRoute <- Nothing
                        , animation <- Nothing
                    }
                    , Effects.none
                    )
                else
                    ( { model | animation <- Just { elapsedTime = newElapsedTime, prevClockTime = clockTime }
                    }
                    , Effects.tick Tick
                    )


-- view

view : Signal.Address Action -> Model -> Html
view address model =
    case model.animation of
        Nothing ->
            UI.Context model.layout model.route.url Routing.pathAddress
                |> model.route.view
                |> UI.render
        Just animation ->
            let
                nextRoute = case model.nextRoute of
                    Just r -> r
                    Nothing -> model.route

                currentScreen =
                    UI.Context model.layout model.route.url Routing.pathAddress
                        |> model.route.view

                nextScreen =
                    UI.Context model.layout nextRoute.url Routing.pathAddress
                        |> nextRoute.view

                alpha =
                    ease easeOutBounce float 0 1 duration animation.elapsedTime
                leftOffset w =
                    round (240 + alpha * (toFloat w - 240))
            in
                case model.layout of
                    UI.Mobile ->
                        div [] [ text "hmmmm" ]
                    UI.Desktop width ->
                        div []
                            [ UI.render nextScreen
                            , div [ class "desktop"]
                                  [ div [class "animating main-content", style [("left", toString (leftOffset width) ++ "px")]] currentScreen.content ]
                            ]

