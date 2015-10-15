module Route where

import Task
import Html

import Layout

type alias Route = Layout.Layout ->
    { header: List Html.Html
    , content: List Html.Html
    , footer: List Html.Html
    }



--linkTo: Route -> Attribute

pathChangeMailbox : Signal.Mailbox (Task.Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

pathSignal : Signal (Task.Task a ())
pathSignal = pathChangeMailbox.signal

pathAddress : Signal.Address (Task.Task a ())
pathAddress = pathChangeMailbox.address

