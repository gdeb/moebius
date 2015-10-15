module Layout where

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


