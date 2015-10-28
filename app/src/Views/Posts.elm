module Views.Posts where

import Html exposing (Html, text, h1, h2, h3, div, p)
import Html.Attributes exposing (class)
import Core exposing (View)
import Date

import Models.Posts exposing (Post, posts)
import Components exposing (genericContent, footer)
import Utils exposing (formatDate, linkTo, find)
import Views.Undefined

view: View
view =
    let
        intro =
            [ div [] [ text "Here are a few interesting thoughts." ] ]
        overviews = List.map renderPostOverview posts
    in
        { title = "Posts"
        , content = genericContent "Posts" (intro ++ overviews) footer
        , fullScreen = False
        }


renderPostOverview: Post -> Html
renderPostOverview post =
    let
        date = div [ class "date" ] [ text (formatDate post.date) ]
        title = h2 [] [ text post.title ]
        summary = List.map (\paragraph -> p [] [text paragraph]) post.summary
        content =
            [ title, date ] ++ summary

        link = linkTo ("/post/" ++ post.urlName ++ ".html")
    in
        div [ class "post overview", link ] content


viewPost: String -> View
viewPost urlName =
    let
        post = find (\p -> p.urlName == urlName) posts
    in
        case post of
            Just post' ->
                { title = "Posts" ++ urlName
                , content = genericContent ("Posts" ++ urlName) (renderPost post') footer
                , fullScreen = False
                }

            Nothing ->
                Views.Undefined.view


renderPost: Post -> List Html
renderPost post =
    let
        title =
            h2 [] [text post.title]

        subtitle =
            h3 [] [ text post.subtitle ]

        date =
            div [] [ text (formatDate post.date) ]
    in
        [title, subtitle, date] ++ post.content


