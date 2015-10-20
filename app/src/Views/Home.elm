module Views.Home where

import Html exposing (Html, text, h1, p, div, h2, ul, li)
import UI

view: UI.View
view =
    { content = \_ -> UI.genericContent "Home" content UI.footer
    , fullScreen = False
    }

content: List Html
content =
    [ h1 [] [text "Home"]
    , div [] [ text "Welcome to gdeb github page."]
    , h2 [] [ text "about me" ]
    , div [] [ text "This is a work in progress" ]
    , h2 [] [ text "Last posts " ]
    , ul []
        [ li [] [text "post on why this blog is interesting" ]
        , li [] [ text "post on client side routing" ]
        , li [] [ text "post on elm?" ]
        , li [] [ text "post on responsive design without mediaqueries" ]
        ]
    ]

