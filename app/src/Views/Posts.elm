module Views.Posts where

import Html exposing (Html, text, h1, h2, h3, div, p, a)
import Html.Attributes exposing (class, href)
import Core exposing (View)

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
        , content = genericContent (always <| intro ++ overviews) footer
        , fullScreen = False
        }


renderPostOverview: Post -> Html
renderPostOverview post =
    let
        date = div [ class "date" ] [ text (formatDate post.date) ]
        title = h2 [ linkTo' post.urlName ] [ a [ href "#" ] [ text post.title ]]
        summary = List.map (\paragraph -> p [] [text paragraph]) post.summary
        content =
            [ title, date ] ++ summary
    in
        div [ class "post overview" ] content


viewPost: String -> View
viewPost urlName =
    let
        post = find (\p -> p.urlName == urlName) posts
    in
        case post of
            Just post' ->
                { title = "Posts" ++ urlName
                , content = genericContent (always <| renderPost post') footer
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


-- utils
linkTo' urlName =
    linkTo ("/post/" ++ urlName ++ ".html")
