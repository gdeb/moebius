module Content.Undefined where

import Html exposing (Html, text, h1, div, p, button)
import Route

--import Routes exposing (linkTo)

route: Route.Route
route layout =
    { header = []
    , content = view
    , footer = []
    }


-- projects
view: List Html
view =
    [ h1 [] [text "Wrong url"]
    , p [] [ text """
        For some reason, you are actually visiting an undefined url.  This is
        most likely a mistake of mine.  I am extremely sorry and will do
        everything in my power to prevent such errors to happen again in the
        future.""" ]
    , p [] [ text "May I suggest that you click on one of these links?" ]
    --, div [] [ button [linkTo Routes.Home] [ text "Home" ]
             --, button [linkTo Routes.About] [ text "About" ]
             --, button [linkTo Routes.Posts] [ text "Posts" ]
             --]
    ]

header: List Html
header =
    [ text "Error 404" ]

