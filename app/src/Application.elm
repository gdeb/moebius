module Application where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Time exposing (Time)
import Easing exposing (ease, float)
import Effects exposing (Effects, Never)

import Common.Types exposing (..)
import Common.Components


duration: Float
duration = Time.second*0.5


-- model
type alias Model =
    { route: Route
    , context: Context
    , animation: Maybe AnimationState
    }


type Direction = Up | Down


type alias AnimationState =
    { prevClockTime : Time
    , elapsedTime: Time
    , nextRoute: Route
    , direction: Direction
    }


init: Route -> Context -> (Model, Effects Action)
init initRoute initContext =
    let model =
        { route = initRoute
        , context = initContext
        , animation = Nothing
        }
    in
        (model, Effects.none)

-- update

type Action
    = UpdateRoute Route
    | UpdateContext Context
    | StartAnimation Route Time
    | Tick Time


update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateRoute route ->
            if route.url == model.route.url || not (model.animation == Nothing) then
                (model, Effects.none)
            else if route.view.fullScreen || model.route.view.fullScreen then
                ({ model | route <- route}, Effects.none)
            else
                (model, Effects.tick (StartAnimation route))

        UpdateContext context ->
            ({ model | context <- context }, Effects.none)

        StartAnimation route clockTime ->
            let direction = if route.sequence > model.route.sequence
                        then Down
                        else Up

                animation =
                    { prevClockTime = clockTime
                    , elapsedTime = 0
                    , nextRoute = route
                    , direction = direction
                    }
            in
                ({ model | animation <- Just animation }, Effects.tick Tick)

        Tick clockTime ->
            case model.animation of
                Nothing -> (model, Effects.none)
                Just animation ->
                    let newElapsedTime =
                        animation.elapsedTime + clockTime - animation.prevClockTime
                    in
                        if newElapsedTime > duration then
                            ( { model | route <- animation.nextRoute, animation <- Nothing }, Effects.none)
                        else
                            let animation' =
                                    { animation | elapsedTime <- newElapsedTime, prevClockTime <- clockTime }
                            in
                                ({ model | animation <- Just animation' }, Effects.tick Tick)


-- view
view : Signal.Address Action -> Model -> Html
view address model =
    let content =
            model.route.view.content model.context

        sidebar =
            if model.context.layout == Mobile || model.route.view.fullScreen then
                []
            else
                [Common.Components.sidebar model.route.url]

        renderContent margin url content' =
            let style' =
                if margin == 0 then [] else [("margin-top", toString margin ++ "px"), ("position", "fixed")]
            in
                div [ class "main-content", style style', key url ] content'
    in
        case model.animation of
            Nothing ->
                case model.context.layout of
                    Mobile ->
                        div [class "mobile" ] content

                    Desktop ->
                        div [ class "desktop" ]
                            (sidebar ++ [renderContent 0 model.route.url content])

            Just animation ->
                let nextContent =
                        animation.nextRoute.view.content model.context

                    alpha =
                        round <| ease Easing.easeInOutExpo float 0 (toFloat model.context.height) duration animation.elapsedTime

                    dir =
                        if animation.direction == Down then -1 else 1
                in
                    case model.context.layout of
                        Mobile ->
                            div [class "mobile" ] content

                        Desktop ->
                            div [ class "desktop" ]
                                (sidebar ++
                                    [ renderContent (dir * alpha) model.route.url content
                                    , renderContent (dir*(alpha - model.context.height)) animation.nextRoute.url nextContent
                                    ])
