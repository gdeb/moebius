module Content.Home where

import Html exposing (Html, text, h1, p)
import Layout
import Elements

render: Layout.UI -> Layout.Screen
render ui =
    { header = [ text "Home" ]
    , content = view
    , footer = Elements.footer
    }

view: List Html
view =
    [ h1 [] [text "Home"]
    , p [] [ text "This is a work in progress" ]
    ]

