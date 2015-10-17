module Views.Undefined where

import Html exposing (Html, text, h1, div, p, button)
import UI exposing (linkTo)

view: UI.View
view context =
    { content = content context
    , sidebar = Nothing
    }


-- projects
content: UI.Context -> List Html
content context =
    [ h1 [] [text "Wrong url"]
    , p [] [ text """
        For some reason, you are actually visiting an undefined url.  This is
        most likely a mistake of mine.  I am extremely sorry and will do
        everything in my power to prevent such errors to happen again in the
        future.""" ]
    , p [] [ text "May I suggest that you click on one of these links?" ]
    , div [] [ button [linkTo context "/"] [ text "Home" ]
             , button [linkTo context "/about.html"] [ text "About" ]
             , button [linkTo context "/posts.html"] [ text "Posts" ]
             ]
    ]


header: List Html
header =
    [ text "Error 404" ]

