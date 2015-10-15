module Content.Projects where

import Html exposing (Html, text, h1, div, p)
import UI

screen: UI.Screen
screen layout =
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


