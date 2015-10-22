module Common.Components where

import Html exposing (..)
import Html.Attributes exposing (class, href)

import Common.Utils exposing (linkTo)


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


