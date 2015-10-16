module Views.Projects where

import Html exposing (Html, text, h1, div, p)
import UI

view: UI.View
view = UI.genericView "Projects" content


-- projects
content: List Html
content =
    [ h1 [] [text "Projects"]
    , p [] [ text "content" ]
    ]


