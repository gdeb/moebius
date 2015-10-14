module Layout where

import Window
import Html exposing (Html, div, text, a, li, ul)

type UI = Desktop Int | Mobile

type alias Screen =
    { header: List Html
    , content: List Html
    , footer: List Html
    }

getUI: Int -> UI
getUI width =
    if width < 1000 then Mobile else Desktop width

uis: Signal UI
uis =
    Window.width
        |> Signal.map getUI
        |> Signal.dropRepeats


