module UI where

import Html
import Window

type Layout = Desktop Int | Mobile

getLayout: Int -> Layout
getLayout width =
    if width < 1000 then Mobile else Desktop width

current: Signal Layout
current =
    Window.width
        |> Signal.map getLayout
        |> Signal.dropRepeats


type alias Screen = Layout ->
    { header: List Html.Html
    , content: List Html.Html
    , footer: List Html.Html
    }

footer: List Html.Html
footer =
    [ Html.text "© 2015 Géry Debongnie, all rights reserved." ]
