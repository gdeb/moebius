module Content.Projects where

import Html exposing (Html, text, h1, div, p)
import Route

route: Route.Route
route layout =
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


