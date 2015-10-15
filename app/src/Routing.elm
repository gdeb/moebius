module Routing where

import Dict exposing (insert)
import History
import Task

import UI

import Views.About
import Views.Home
import Views.Posts
import Views.Projects
import Views.Undefined

type alias Route =
    { view: UI.Screen
    , url: String
    }

undefinedRoute: Route
undefinedRoute =
    Route Views.Undefined.view "404"

type alias Routes = Dict.Dict String Route

routes: Routes
routes =
    let addRoute url view routes =
        Dict.insert url (Route view url) routes
    in
        Dict.empty
            |> addRoute "/" Views.Home.view
            |> addRoute "/index.html" Views.Home.view
            |> addRoute "/about.html" Views.About.view
            |> addRoute "/posts.html" Views.Posts.view
            |> addRoute "/projects.html" Views.Projects.view

getRoute: String -> Route
getRoute url =
    case Dict.get url routes of
        Just route -> route
        Nothing -> undefinedRoute


currentRoute: Signal Route
currentRoute =
    Signal.map getRoute History.path


pathChangeMailbox : Signal.Mailbox (Task.Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathSignal : Signal (Task.Task a ())
pathSignal = pathChangeMailbox.signal

pathAddress : Signal.Address (Task.Task a ())
pathAddress = pathChangeMailbox.address

