module Common.Types where

import Html exposing (Html)

type Layout = Desktop | Mobile

type alias Context =
    { layout: Layout
    , width: Int
    , height: Int
    }

type alias View =
    { content: Context -> List Html
    , fullScreen: Bool
    }


type alias Route =
    { view: View
    , url: String
    , sequence: Int
    }

