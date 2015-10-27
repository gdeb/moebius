module Core where

import Task
import Html exposing (Html)

type Layout = Desktop | Mobile

type alias Context =
    { layout: Layout
    , width: Int
    , height: Int
    }

type alias View =
    { title: String
    , content: Context -> List Html
    , fullScreen: Bool
    }


type alias Route =
    { view: View
    , url: String
    , sequence: Int
    }


type Direction = Up | Down


pathChangeMailbox : Signal.Mailbox (Task.Task error ())
pathChangeMailbox = Signal.mailbox (Task.succeed ())

