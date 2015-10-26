module Utils where

import Html
import Html.Events
import History

import Core exposing (pathChangeMailbox)


linkTo : String -> Html.Attribute
linkTo url =
    History.setPath url |> Html.Events.onClick pathChangeMailbox.address

sign : Int -> Int
sign x =
    if x < 0 then
        -1
    else if x == 0 then
        0
    else
        1

