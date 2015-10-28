module Models.Posts where

import Html exposing (Html, text, h1, h2, h3, div)
import Date exposing (Date)

import Utils exposing (unsafeReadDate)

type alias Post =
    { title: String
    , subtitle: String
    , date: Date
    , urlName: String
    , summary: List String
    , content: List Html
    }


posts : List Post
posts =
    [ firstPost, test1, onResponsiveDesign ]
        |> List.sortBy (Date.toTime << .date)
        |> List.reverse

-- posts

firstPost : Post
firstPost =
    { title = "First post"
    , subtitle = "Introducing my github page"
    , date = unsafeReadDate "10/27/2015"
    , urlName = "first-post"
    , summary = [ "This post explains the motivation behind this page, and highlight some of its technical characteristics."]
    , content = [ div [] [text "main content"], div [] [text "other stuff"] ]
    }

test1 : Post
test1 =
    { title = "Client side routing"
    , subtitle = "Small subtitle to highlight important stuff"
    , date = unsafeReadDate "10/29/2015"
    , urlName = "client-side-routing"
    , summary = [ "summary. this is a paragraph", "and this is another"]
    , content = [ div [] [text "main content"], div [] [text "other stuff"] ]
    }

onResponsiveDesign : Post
onResponsiveDesign =
    { title = "On responsive design"
    , subtitle = "You don't need no media queries"
    , date = unsafeReadDate "10/28/2015"
    , urlName = "on-responsive-design"
    , summary =
        [ """Responsive websites traditionally uses css to achieve different layouts.
          In this post, I'll explain why I believe that it is a bad practice, and how we can do better
          """
        ]
    , content = [ div [] [] ]
    }



