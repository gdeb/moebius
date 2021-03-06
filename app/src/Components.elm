module Components where

import Html exposing (..)
import Html.Attributes exposing (class, href, style)

import Utils exposing (linkTo)
import Core exposing (Context, Layout)


genericContent : (Context -> List Html) -> List Html -> Context -> List Html
genericContent render footer context =
    [ div [ class "content" ] (render context)
    , div [ class "footer" ] footer
    ]


footer : List Html
footer =
    [ text "© 2015 Géry Debongnie, all rights reserved." ]


sidebar : String -> Html
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

navbar : Attribute -> String -> Html
navbar onClick title =
    div [class "navbar" ]
        [ span [ class "hamburger", onClick ] [ i [ class "icono-bars" ] [] ]
        , span [ class "title" ] [ text title ]
        ]

drawer : String -> Int -> Html
drawer url maxHeight =
    let
        attrs url' =
            if url' == url then [class "disabled"] else [linkTo url']

        makeListItem url' descr =
            li (attrs url') [ text descr ]
    in
        ul [ class "drawer", style [("max-height", (toString maxHeight) ++ "px")] ]
           [ makeListItem "/" "home"
           , makeListItem "/about.html" "about me"
           , makeListItem "/posts.html" "posts"
           , makeListItem "/projects.html" "projects"
           ]

