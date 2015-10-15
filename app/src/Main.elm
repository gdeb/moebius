module Main where

import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp

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
    , layout: UI.Layout
    }


init: (Model, Effects Action)
init =
    let model =
        Model (Routing.getRoute initialPath) (UI.getLayout initialWidth)
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Routing.Route
    | UpdateLayout UI.Layout


update: Action -> Model -> (Model, Effects Action)
update action model =
    let model' =
        case action of
            UpdateRoute route -> { model | route <- route }
            UpdateLayout layout -> { model | layout <- layout }
    in
        (model', Effects.none)


-- view

view : Signal.Address Action -> Model -> Html
view address model =
    let
        context =
            UI.Context model.layout model.route.url Routing.pathAddress
    in
        model.route.view context

