module Views.Projects where

import Html exposing (Html, text, h1, div, p, h2, ul, li)
import Common.Types exposing (View)

import Models.Projects exposing (Project, projects)
import Common.Components exposing (genericContent, footer)

view: View
view =
    { title = "Projects"
    , content = genericContent "Projects" content footer
    , fullScreen = False
    }

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

