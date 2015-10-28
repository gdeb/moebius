module Main where

import Dict
import Effects exposing (Effects, Never)
import History
import Html exposing (..)
import StartApp as StartApp
import Task exposing (Task)
import Window

import Application
import Core exposing (..)
import Models.Posts
import Views.About
import Views.Home
import Views.Posts
import Views.Projects
import Views.Undefined


-- main

app: StartApp.App Application.Model
app =
    let routes =
            History.path
                |> Signal.map (Application.UpdateRoute << getRoute)

        contexts =
            Window.dimensions
                |> Signal.map (Application.UpdateContext << getContext)

        route = getRoute initialPath
        context = getContext (initialWidth, initialHeight)
    in
        StartApp.start
            { init = Application.init route context
            , view = Application.view
            , update = Application.update
            , inputs = [routes, contexts]
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


-- routes

undefinedRoute: Route
undefinedRoute =
    Route Views.Undefined.view "404" 999

type alias Routes = Dict.Dict String Route

routes: Routes
routes =
    let
        (:->) url (view, seq) = (url, Route view url seq)

        staticRoutes =
            [ "/"              :-> (Views.Home.view, 0)
            , "/index.html"    :-> (Views.Home.view, 0)
            , "/about.html"    :-> (Views.About.view, 10)
            , "/posts.html"    :-> (Views.Posts.view, 20)
            , "/projects.html" :-> (Views.Projects.view, 30)
            , "/post/blip.html" :-> (Views.Posts.view, 21)
            ]

        postRoute seq post =
            let
                url = "/post/" ++ post.urlName ++ ".html"
            in
                url :-> (Views.Posts.viewPost post.urlName, 21 + seq)

        postRoutes = List.indexedMap postRoute Models.Posts.posts

    in
        Dict.fromList (staticRoutes ++ postRoutes)


getRoute: String -> Route
getRoute url =
    case Dict.get url routes of
        Just route -> route
        Nothing -> undefinedRoute


-- helpers
getContext: (Int, Int) -> Context
getContext (width, height) =
   { layout = if width < 768 then Mobile else Desktop
   , width = width
   , height = height
   }


