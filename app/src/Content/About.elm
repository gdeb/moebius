module Content.About where

import Html exposing (Html, text, h1, p)

import Layout

render: Layout.UI -> Layout.Screen
render ui =
    { header = []
    , content = view
    , footer = []
    }

view: List Html
view =
    [ h1 [] [text "About"]
    , p [] [ text "content" ]
    ]


