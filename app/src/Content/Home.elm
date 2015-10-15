module Content.Home where

import Html exposing (Html, text, h1, p)
import UI

screen: UI.Screen
screen = UI.genericView view

view: List Html
view =
    [ h1 [] [text "Home"]
    , p [] [ text "This is a work in progress" ]
    ]

