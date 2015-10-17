module Views.Projects where

import Html exposing (Html, text, h1, div, p, h2)
import UI

view: UI.View
view = UI.genericView "Projects" content

projects : List Project
projects =
    [ moebius ]


content: List Html
content =
    [ h1 [] [text "Projects"] ] ++ (List.concatMap renderProject projects)


type alias Project =
    { name: String
    , repo: String
    , description: List String
    }

renderProject: Project -> List Html
renderProject project =
    let
        title =
            h1 [] [ text project.name ]
        subtitle =
            h2 [] [ text ("Repository: " ++ project.repo) ]
        content =
            List.map (\paragraph -> p [] [ text paragraph ]) project.description
    in
        [title, subtitle] ++ content

-- projects
moebius: Project
moebius =
    { name = "Moebius"
    , repo = "https://github.com/gdeb/moebius"
    , description =
        [ "This is an experiment in a single page application. The code of this website is actually the javascript compiled by this project."
        , "I'll develop more later on why this is interesting"
        ]
    }
