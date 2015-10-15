module Views.Undefined where

import Html exposing (Html, text, h1, div, p, button)
import Html.Attributes exposing (class, style)
import UI exposing (linkTo)

view: UI.Screen
view context =
    case context.layout of
        UI.Mobile ->
            div [ class "mobile" ]
                [ div [ class "header" ] [ text "Wrong url" ]
                , div [ class "content" ] (content context)
                , div [ class "footer" ] []
                ]
        UI.Desktop width ->
            div [ style [ ("padding", "30px") ] ] (content context)


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

