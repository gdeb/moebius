module App where

import Html exposing (Html, div, button, text, ul, a, li)
import Html.Attributes exposing (class, href)
import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp as StartApp

import Layout
import Route
import Routes

-- main

app: StartApp.App Model
app =
    let
        paths = Signal.map UpdateRoute Routes.currentRoute
        uis = Signal.map UpdateLayout Layout.current
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
port runTask = Route.pathSignal


-- model
type alias Model =
    { route: Route.Route
    , layout: Layout.Layout
    }


init: (Model, Effects Action)
init =
    let model =
        Model (Routes.getRoute initialPath) (Layout.getLayout initialWidth)
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Route.Route
    | UpdateLayout Layout.Layout


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
        elements =
            model.route model.layout

        mainContent =
            [ div [ class "header" ] elements.header
            , div [ class "content" ] elements.content
            , div [ class "footer" ] elements.footer
            ]
    in
        case model.layout of
            Layout.Mobile ->
                div [ class "mobile" ] mainContent
            Layout.Desktop width ->
                div [ class "desktop" ]
                    [ sidebar model.route
                    , div [ class "main-content" ] mainContent
                    ]

sidebar: Route.Route -> Html
sidebar current =
    let
        -- isActive location =
            -- if location == current then [class "active"] else []

        makeListItem = 1
        -- makeListItem location descr =
            -- li ([linkTo location] ++ (isActive location))
            -- [ a [href (Routes.getUrl location)] [ text descr ]
            -- ]
    in
        div [ class "sidebar" ]
            [ div [ class "title" ] [ text "gdeb" ]
            , ul [] []
                -- [ makeListItem Routes.About "about"
                -- , makeListItem Routes.Posts "posts"
                -- , makeListItem Routes.Projects "projects"
                -- ]
            ]

