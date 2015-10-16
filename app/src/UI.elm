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


type alias Screen =
    { sidebar: Maybe Html
    , content: List Html
    }

type alias View = Context -> Screen

-- layout related functions

genericView: String -> List Html -> View
genericView title content context =
    let
        content' =
            [ div [ class "header" ] (header title)
            , div [ class "content" ] content
            , div [ class "footer" ] footer
            ]

        sidebar' =
            case context.layout of
                Mobile -> Nothing
                Desktop _ -> Just (sidebar context)
    in
        Screen sidebar' content'


header: String -> List Html
header title =
    [ text title ]


footer: List Html
footer =
    [ text "© 2015 Géry Debongnie, all rights reserved." ]


sidebar: Context -> Html
sidebar context =
    let
        isActive url =
            if url == context.url then [class "active"] else []

        makeListItem url descr =
            li ([linkTo context url] ++ (isActive url))
            [ a [href url] [ text descr ]
            ]
    in
        div [ class "sidebar" ]
            [ div [ class "title", linkTo context "/" ] [ text "gdeb" ]
            , ul []
                [ makeListItem "/about.html" "about"
                , makeListItem "/posts.html" "posts"
                , makeListItem "/projects.html" "projects"
                ]
            ]

-- utility
linkTo: Context -> String -> Html.Attribute
linkTo context url =
    History.setPath url |> Html.Events.onClick context.path

