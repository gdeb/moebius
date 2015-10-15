module Routes where

import Dict exposing (insert)
import History exposing (setPath)

import Route

import Content.About
import Content.Home
import Content.Posts
import Content.Projects
import Content.Undefined

routes: Dict.Dict String Route.Route
routes =
    Dict.empty
        |> insert "/" Content.Home.route
        |> insert "/index.html" Content.Home.route
        |> insert "/about.html" Content.About.route
        |> insert "/posts.html" Content.Posts.route
        |> insert "/projects.html" Content.Projects.route

getRoute: String -> Route.Route
getRoute url =
    case Dict.get url routes of
        Just route -> route
        Nothing -> Content.Undefined.route


currentRoute: Signal Route.Route
currentRoute =
    Signal.map getRoute History.path




