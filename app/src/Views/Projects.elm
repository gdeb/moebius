module Views.Projects where

import Html exposing (Html, text, h1, div, p, h2, ul, li)
import UI

view: UI.View
view =
    { content = \_ -> UI.genericContent "Projects" content UI.footer
    , fullScreen = False
    }

projects : List Project
projects =
    [ moebius ]


content: List Html
content =
    let
        title =
             h1 [] [text "Projects"]

        intro =
            p [] [ text "Here is a selection of my most interesting projects" ]

        workProjects =
            [ h2 [] [ text "Work related (Odoo)" ]
            , ul []
                [ li [] [ text "full rewrite of the graph view " ]
                , li [] [ text "creation of the pivot view" ]
                , li [] [ text "full rewrite of the kanban view" ]
                , li [] [ text "modularisation of the javascript code" ]
                , li [] [ text "large part of the chat interface in Odoo" ]
                , li [] [ text "redesign of the web client (material design)" ]
                ]
            ]
        hobbyProjects =
            [ h2 [] [ text "Hobby projects" ] ]
                ++ (List.concatMap renderProject projects)
    in
        [title, intro] ++ workProjects ++ hobbyProjects



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
