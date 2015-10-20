module UI where

import Html exposing (Html, ul, li, div, text, a)
import Html.Attributes exposing (class, href)
import Html.Events
import History

import Window
import Task

type Layout = Desktop | Mobile

type alias Context =
    { layout: Layout
    , width: Int
    , height: Int
    }

type alias View =
    { content: Context -> List Html
    , fullScreen: Bool
    }

getContext: (Int, Int) -> Context
getContext (width, height) =
   { layout = if width < 1000 then Mobile else Desktop
   , width = width
   , height = height
   }

current: Signal Context
current =
    Window.dimensions
        |> Signal.map getContext



genericContent: String -> List Html -> List Html -> List Html
genericContent title content footer =
    [ div [ class "header" ] (header title)
    , div [ class "content" ] content
    , div [ class "footer" ] footer
    ]


header: String -> List Html
header title =
    [ text title ]


footer: List Html
footer =
    [ text "© 2015 Géry Debongnie, all rights reserved." ]


sidebar: String -> Html
sidebar url =
    let
        isActive url' =
            if url' == url then [class "active"] else []

        makeListItem url' descr =
            li ([linkTo url'] ++ (isActive url'))
            [ a [href url'] [ text descr ]
            ]
    in
        div [ class "sidebar" ]
            [ div [ class "title", linkTo "/" ] [ text "gdeb" ]
            , ul []
                [ makeListItem "/about.html" "about me"
                , makeListItem "/posts.html" "posts"
                , makeListItem "/projects.html" "projects"
                ]
            ]

-- utility
pathChangeMailbox : Signal.Mailbox (Task.Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathSignal : Signal (Task.Task a ())
pathSignal = pathChangeMailbox.signal

pathAddress : Signal.Address (Task.Task a ())
pathAddress = pathChangeMailbox.address

linkTo: String -> Html.Attribute
linkTo url =
    History.setPath url |> Html.Events.onClick pathAddress

