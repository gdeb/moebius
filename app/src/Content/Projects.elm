module Content.Projects where

import Html exposing (Html, text, h1, div, p)
import Layout

render: Layout.UI -> Layout.Screen
render ui =
    { header = []
    , content = view
    , footer = []
    }


-- projects
view: List Html
view =
    [ h1 [] [text "Projects"]
    , p [] [ text "content" ]
    ]


