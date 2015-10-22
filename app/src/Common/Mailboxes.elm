module Common.Mailboxes where

import Task

pathChangeMailbox : Signal.Mailbox (Task.Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

