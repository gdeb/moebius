module Common.Utils where

import Html
import Html.Events
import History

import Common.Mailboxes exposing (pathChangeMailbox)


linkTo: String -> Html.Attribute
linkTo url =
    History.setPath url |> Html.Events.onClick pathChangeMailbox.address

