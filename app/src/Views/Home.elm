module Views.Home where

import Html exposing (Html, text, h1, p, div, h2, ul, li)
import Common.Types exposing (View)
import Common.Components exposing (genericContent, footer)

view: View
view =
    { title = "Home"
    , content = genericContent "Home" content footer
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

