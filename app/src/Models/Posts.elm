module Models.Posts where

import Html exposing (Html, text, h1, h2, h3, div)
import Date exposing (Date)

type alias Post =
    { title: String
    , subtitle: String
    , date: Date
    , summary: List String
    , content: List Html
    }


posts : List Post
posts =
    [ test1, test1, test1 ]

-- posts

test1: Post
test1 =
    { title = "A test post"
    , subtitle = "Small subtitle to highlight important stuff"
    , date = unsafeReadDate "10/19/2016"
    , summary = [ "summary. this is a paragraph", "and this is another"]
    , content = [ div [] [text "main content"], div [] [text "other stuff"] ]
    }




unsafeReadDate : String -> Date
unsafeReadDate value =
    case Date.fromString value of
       Ok date -> date
