module Animation where

import Effects exposing (Effects)
import Time exposing (Time)


type alias Animation description=
    { prevClockTime : Time
    , elapsedTime : Time
    , duration : Time
    , description : description
    }


tick : (Animation description) -> Time -> Maybe (Animation description)
tick animation time =
    let
        elapsedTime = animation.elapsedTime + time - animation.prevClockTime
    in
        if elapsedTime > animation.duration then
            Nothing

        else
            Just { animation | elapsedTime <- elapsedTime, prevClockTime <- time }


noFx : model -> (model, Effects a)
noFx model =
    (model, Effects.none)

withFx : (Time -> action) -> model -> (model, Effects action)
withFx action model = (model, Effects.tick action)


type alias Model m a = { m | animation : Maybe a }

dispatchFx : (Time -> action) -> Model m a -> (Model m a, Effects action)
dispatchFx tick model =
    case model.animation of
        Just anim ->
            withFx tick model

        Nothing ->
            noFx model


getRatio : Maybe (Animation description) -> Float
getRatio animation =
    let
        getRatio' anim = anim.elapsedTime / anim.duration
    in
        animation  -- move this to animation
            |> Maybe.map getRatio'
            |> Maybe.withDefault 1


