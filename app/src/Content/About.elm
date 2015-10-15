module Content.About where

import Html exposing (Html, text, h1, p)

import UI

screen: UI.Screen
screen ui =
    { header = []
    , content = view
    , footer = UI.footer
    }

view: List Html
view =
    [ h1 [] [text "About"]
    , p [] [ text "content" ]
    ]


