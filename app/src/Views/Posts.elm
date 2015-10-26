module Views.Posts where

import Html exposing (Html, text, h1, h2, h3, div)
import Core exposing (View)
import Date.Format exposing (format)

import Models.Posts exposing (Post, posts)
import Components exposing (genericContent, footer)

view: View
view =
    { title = "Posts"
    , content = genericContent "Posts" content footer
    , fullScreen = False
    }


content: List Html
content =
    [ h1 [] [text "Posts"] ] ++ (List.concatMap renderPost posts)

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

formatDate = format "%B %e, %Y"

