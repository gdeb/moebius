module Views.Posts where

import Html exposing (Html, text, h1, h2, h3, div)
import UI
import Date exposing (Date)
import Date.Format exposing (format)

view: UI.View
view =
    { content = \_ -> UI.genericContent "Posts" content UI.footer
    , fullScreen = False
    }

posts : List Post
posts =
    [ test1, test1, test1 ]


content: List Html
content =
    [ h1 [] [text "Posts"] ] ++ (List.concatMap renderPost posts)

type alias Post =
    { title: String
    , subtitle: String
    , date: Date
    , summary: List String
    , content: List Html
    }

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

-- posts

test1 =
    { title = "A test post"
    , subtitle = "Small subtitle to highlight important stuff"
    , date = unsafeReadDate "10/19/2016"
    , summary = [ "summary. this is a paragraph", "and this is another"]
    , content = [ div [] [text "main content"], div [] [text "other stuff"] ]
    }

formatDate = format "%B %e, %Y"

unsafeReadDate : String -> Date
unsafeReadDate value =
    case Date.fromString value of
       Ok date -> date
