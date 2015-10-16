module Views.Home where

import Html exposing (Html, text, h1, p)
import UI

view: UI.View
view = UI.genericView "Home" content

content: List Html
content =
    [ h1 [] [text "Home"]
    , p [] [ text "This is a work in progress" ]
    ]

