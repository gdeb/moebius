module Content.Home where

import Html exposing (Html, text, h1, p)
import UI
import Shared

screen: UI.Screen
screen ui =
    { header = [ text "Home" ]
    , content = view
    , footer = Shared.footer
    }

view: List Html
view =
    [ h1 [] [text "Home"]
    , p [] [ text "This is a work in progress" ]
    ]

