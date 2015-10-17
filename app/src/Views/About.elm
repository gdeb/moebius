module Views.About where

import Html exposing (Html, text, h1, p)

import UI exposing (View)

view: View
view =
    UI.genericView "About" content


content: List Html
content =
    [ h1 [] [text "About"]
    , p [] [ text "content" ]
    ]


