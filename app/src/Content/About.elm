module Content.About where

import Html exposing (Html, text, h1, p)

import UI
import Shared

screen: UI.Screen
screen ui =
    { header = []
    , content = view
    , footer = Shared.footer
    }

view: List Html
view =
    [ h1 [] [text "About"]
    , p [] [ text "content" ]
    ]


