module UI where

import Html exposing (Html, ul, li, div, text, a)
import Html.Attributes exposing (class, href)
import Html.Events
import History

import Window
import Task

type Layout = Desktop Int | Mobile

getLayout: Int -> Layout
getLayout width =
    if width < 1000 then Mobile else Desktop width

current: Signal Layout
current =
    Window.width
        |> Signal.map getLayout
        |> Signal.dropRepeats


type alias Context =
    { layout: Layout
    , url: String
    , path: Signal.Address (Task.Task String ())
    }


type alias Screen = Context -> Html

footer: List Html.Html
footer =
    [ Html.text "© 2015 Géry Debongnie, all rights reserved." ]

sidebar: Context -> Html
sidebar context =
    let
        isActive url =
            if url == context.url then [class "active"] else []

        linkTo url =
            History.setPath url |> Html.Events.onClick context.path

        makeListItem url descr =
            li ([linkTo url] ++ (isActive url))
            [ a [href url] [ text descr ]
            ]
    in
        div [ class "sidebar" ]
            [ div [ class "title", linkTo "/" ] [ text "gdeb" ]
            , ul []
                [ makeListItem "/about.html" "about"
                , makeListItem "/posts.html" "posts"
                , makeListItem "/projects.html" "projects"
                ]
            ]


genericView: List Html -> Context -> Html
genericView content context =
    let
        content' =
            [ div [ class "header" ] []
            , div [ class "content" ] content
            , div [ class "footer" ] []
            ]
    in
        case context.layout of
            Mobile ->
                div [ class "mobile" ] content'
            Desktop width ->
                div [ class "desktop" ]
                    [ sidebar context
                    , div [ class "main-content" ] content'
                    ]

