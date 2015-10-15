module Content.Projects where

import Html exposing (Html, text, h1, div, p)
import UI

screen: UI.Screen
screen = UI.genericView view


-- projects
view: List Html
view =
    [ h1 [] [text "Projects"]
    , p [] [ text "content" ]
    ]


