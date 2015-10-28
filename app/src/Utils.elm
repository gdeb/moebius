module Utils where

import Date exposing (Date)
import Date.Format exposing (format)
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


unsafeReadDate : String -> Date
unsafeReadDate value =
    case Date.fromString value of
       Ok date -> date


formatDate : Date.Date -> String
formatDate =
    format "%B %e, %Y"

find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first::rest ->
            if predicate first then
                Just first
            else
                find predicate rest
