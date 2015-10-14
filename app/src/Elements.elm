module Elements where

import Html exposing (Html, ul, li, a, div, text)
import Html.Attributes exposing (class, href)

import Routes exposing (Location, linkTo)


sidebar: Location -> Html
sidebar current =
    let
        isActive location =
            if location == current then [class "active"] else []

        makeListItem location descr =
            li ([linkTo location] ++ (isActive location))
            [ a [href (Routes.getUrl location)] [ text descr ]
            ]
    in
        div [ class "sidebar" ]
            [ div [ class "title", linkTo Routes.Home ] [ text "gdeb" ]
            , ul []
                [ makeListItem Routes.About "about"
                , makeListItem Routes.Posts "posts"
                , makeListItem Routes.Projects "projects"
                ]
            ]

footer: List Html
footer =
    [ text "© 2015 Géry Debongnie, all rights reserved." ]
