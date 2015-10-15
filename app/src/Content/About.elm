module Content.About where

import Html exposing (Html, text, h1, p)

import Route

route: Route.Route
route ui =
    { header = []
    , content = view
    , footer = []
    }

view: List Html
view =
    [ h1 [] [text "About"]
    , p [] [ text "content" ]
    ]


