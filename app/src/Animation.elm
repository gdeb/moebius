module Animation where

import Time exposing (Time)


type Animation model state = Animation
    { prevClockTime : Time
    , elapsedTime : Time
    , duration : Time
    , state : state
    , updateState : Float -> state -> state
    , updateModel : Float -> Animation model state -> model -> model
    }

tick : Animation model state -> model -> Time -> Maybe model
tick animation model time =
    let
        anim = case animation of
            Animation a -> a

        newElapsedTime = anim.elapsedTime + time - anim.prevClockTime
        alpha = newElapsedTime / anim.duration
    in
        if newElapsedTime > anim.duration then
            Nothing
        else
            let
                newAnim = Animation
                    { anim | prevClockTime <- anim.prevClockTime
                           , elapsedTime <- newElapsedTime
                           , state <- anim.updateState alpha anim.state
                    }
            in
                Just (anim.updateModel alpha newAnim model)


