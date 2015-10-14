module Routes where

import Task exposing (Task)
import Html exposing (Attribute)
import History exposing (setPath)
import Html.Events exposing (onClick)

import Layout exposing (Screen)
import Content.About

pathChangeMailbox : Signal.Mailbox (Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathSignal = pathChangeMailbox.signal

pathAddress = pathChangeMailbox.address

type Location = Home | About | Posts | Projects | Undefined


getRoute : String -> Location
getRoute url =
    case url of
        "/" -> Home
        "/index.html" -> Home
        "/about.html" -> About
        "/posts.html" -> Posts
        "/projects.html" -> Projects
        _ -> Undefined

getUrl : Location -> String
getUrl location =
    case location of
        Home -> "/"
        About -> "/about.html"
        Posts -> "/posts.html"
        Projects -> "/projects.html"
        Undefined -> "/"

linkTo: Location -> Attribute
linkTo location =
    location
    |> getUrl
    |> setPath
    |> onClick pathAddress


locations: Signal Location
locations = Signal.map getRoute History.path
