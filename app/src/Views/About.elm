module Views.About where

import Html exposing (Html, text, div, h1, h2, p, li, ul, a)
import Html.Attributes exposing (href)

import UI exposing (View)

view: UI.View
view =
    { content = \_ -> UI.genericContent "About" content UI.footer
    , fullScreen = False
    }


content: List Html
content =
    [ h1 [] [text "About me"]
    , div [] [ text "basic information: email, name, picture" ]
    , p [] [ text "This page is basically just my autopromotion. So, here's an ultra short biography: I'm a software developer, I love technology, in particular web technology.  I also have a background in mathematics. I currently work at Odoo, mostly on the web client." ]
    , h2 [] [ text "Short Biography" ]
    , p [] [ text "insert here informations about me, ..."]
    , p [] [ text "please check my projects page for more information, ..."]
    , h2 [] [ text "Technologies" ]
    , p [] [ text "Some technologies that I know : javascript, python, git, standard web stuff, ..."]
    , p [] [ text "Some technologies that I would like to know more : Elm, Elixir, Rust, Erlang, ..."]
    , h2 [] [ text "Other informations" ]
    , ul []
        [ li [] [ text "link to my github page" ]
        , li [] [ text "link to my linked in page" ]
        , li [] [ text "link to download my resume"
                , a [href "resume.pdf" ] [ text "Resume" ] ]
        ]
    ]


