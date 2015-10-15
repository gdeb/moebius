module Routing where

import Dict exposing (insert)
import History
import Task

import UI

import Content.About
import Content.Home
import Content.Posts
import Content.Projects
import Content.Undefined

type alias Route =
    { screen: UI.Screen
    , url: String
    }

undefinedRoute: Route
undefinedRoute =
    Route Content.Undefined.screen "404"

type alias Routes = Dict.Dict String Route

routes: Routes
routes =
    let addRoute url screen routes =
        Dict.insert url (Route screen url) routes
    in
        Dict.empty
            |> addRoute "/" Content.Home.screen
            |> addRoute "/index.html" Content.Home.screen
            |> addRoute "/about.html" Content.About.screen
            |> addRoute "/posts.html" Content.Posts.screen
            |> addRoute "/projects.html" Content.Projects.screen

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

