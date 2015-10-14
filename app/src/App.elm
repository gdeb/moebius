module App where

import Html exposing (Html, div, button, text, ul, a, li)
import Html.Attributes exposing (class, href)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp

import Layout
import Content.About
import Content.Home
import Content.Posts
import Content.Projects
import Content.Undefined
import Routes exposing (Location, pathSignal, linkTo, locations)
import Elements

-- main

app: StartApp.App Model
app =
    let
        paths = Signal.map UpdatePath Routes.locations
        uis = Signal.map UpdateUI Layout.uis
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

port tasks : Signal (Task Never ())
port tasks = app.tasks

port initialPath: String

port initialWidth: Int

port runTask : Signal (Task error ())
port runTask = pathSignal


-- model
type alias Model =
    { location: Location
    , ui: Layout.UI
    }


init: (Model, Effects Action)
init =
    let model =
        Model (Routes.getRoute initialPath) (Layout.getUI initialWidth)
    in
        (model, Effects.none)

-- update

type Action
    = UpdatePath Location
    | UpdateUI Layout.UI


update: Action -> Model -> (Model, Effects Action)
update action model =
    let model' =
        case action of
            UpdatePath location -> { model | location <- location }
            UpdateUI ui -> { model | ui <- ui }
    in
        (model', Effects.none)

renderElements: Location -> Layout.UI -> Layout.Screen
renderElements location ui =
    case location of
        Routes.About -> Content.About.render ui
        Routes.Home -> Content.Home.render ui
        Routes.Posts -> Content.Posts.render ui
        Routes.Projects -> Content.Projects.render ui
        Routes.Undefined -> Content.Undefined.render ui

-- view
view : Signal.Address Action -> Model -> Html
view address model =
    let
        elements =
            renderElements model.location model.ui

        mainContent =
            [ div [ class "header" ] elements.header
            , div [ class "content" ] elements.content
            , div [ class "footer" ] elements.footer
            ]
    in
        case model.ui of
            Layout.Mobile ->
                div [ class "mobile" ] mainContent
            Layout.Desktop width ->
                div [ class "desktop" ]
                    [ Elements.sidebar model.location
                    , div [ class "main-content" ] mainContent
                    ]

