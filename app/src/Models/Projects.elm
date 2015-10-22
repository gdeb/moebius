module Models.Projects where

type alias Project =
    { name: String
    , repo: String
    , description: List String
    }


projects : List Project
projects =
    [ moebius ]

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
