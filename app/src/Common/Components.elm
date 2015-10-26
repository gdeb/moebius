module Common.Components where

import Html exposing (..)
import Html.Attributes exposing (class, href, style)

import Common.Utils exposing (linkTo)
import Common.Types exposing (Context, Layout)


genericContent: String -> List Html -> List Html -> Context -> List Html
genericContent title content footer context =
    case context.layout of
        Common.Types.Mobile ->
            [ div [ class "content" ] content
            , div [ class "footer" ] footer
            ]

        Common.Types.Desktop ->
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

navbar: Attribute -> String -> Html
navbar onClick title =
    div [class "navbar", onClick ]
        [ div [class "icono-bars"] []
        , text title
        ]

drawer: Int -> Html
drawer maxHeight =
    ul [ class "drawer", style [("max-height", (toString maxHeight) ++ "px")] ]
       [ li [ linkTo "/" ] [ text "home" ]
       , li [ linkTo "/about.html" ] [ text "about me" ]
       , li [ linkTo "/posts.html" ] [ text "posts" ]
       , li [ linkTo "/projects.html" ] [ text "projects" ]
       ]
