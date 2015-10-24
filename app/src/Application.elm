module Application where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Time exposing (Time)
import Easing exposing (ease, float)
import Effects exposing (Effects, Never)

import Animation exposing (..)
import Common.Types exposing (..)
import Common.Components

duration: Float
duration = Time.second*0.4


-- model
type alias Model =
    { route: Route
    , context: Context
    , animation: Maybe (Animation Description)
    }


type Description = RouteTransition Route



init: Route -> Context -> (Model, Effects Action)
init initRoute initContext =
    noFx
        { route = initRoute
        , context = initContext
        , animation = Nothing
        }

-- update

type Action
    = UpdateRoute Route
    | UpdateContext Context
    | StartAnimation Description Time
    | Tick Time



update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateRoute route ->
            if route.url == model.route.url then
                noFx model

            else if not (model.animation == Nothing) then
                noFx model

            else if route.view.fullScreen || model.route.view.fullScreen then
                noFx { model | route <- route}

            else
                withFx (StartAnimation (RouteTransition route)) model

        UpdateContext context ->
            noFx { model | context <- context }

        StartAnimation description clockTime ->
            let
                animation = Animation clockTime 0 duration description
            in
                withFx Tick { model | animation <- Just animation }

        Tick clockTime ->
            case model.animation of
                Just animation ->
                    let
                        animation' = tick animation clockTime
                    in
                        { model | animation <- animation' }
                            |> updateModel animation.description
                            |> dispatchFx Tick

                Nothing ->
                    noFx model



updateModel : Description -> Model -> Model
updateModel description model =
    let
        ratio = getRatio model.animation
    in
        case description of
            RouteTransition route ->
                if ratio < 1 then
                    model

                else
                    { model | route <- route }



-- view
view : Signal.Address Action -> Model -> Html
view address model =
    let
        content =
            model.route.view.content model.context

        sidebar =
            if model.context.layout == Mobile || model.route.view.fullScreen then
                []
            else
                [Common.Components.sidebar model.route.url]
    in
        case model.animation of
            Just animation ->
                case animation.description of
                    RouteTransition route ->
                        let
                            nextContent = route.view.content model.context
                            alpha =
                                computeMargin model.context.height animation.elapsedTime

                            dir =
                                if route.sequence < model.route.sequence then
                                    1
                                else
                                    -1
                        in
                            case model.context.layout of
                                Mobile ->
                                    div [class "mobile" ] content

                                Desktop ->
                                    div [ class "desktop" ]
                                        (sidebar ++
                                            [ renderContent (dir * alpha) model.route.url content
                                            , renderContent (dir*(alpha - model.context.height)) route.url nextContent
                                            ])

            Nothing ->
                case model.context.layout of
                    Mobile ->
                        div [class "mobile" ] content

                    Desktop ->
                        div [ class "desktop" ]
                            (sidebar ++ [renderContent 0 model.route.url content])


renderContent : Int -> String -> List Html -> Html
renderContent margin url content' =
    let style' =
        if margin == 0 then [] else [("margin-top", toString margin ++ "px"), ("position", "fixed")]
    in
        div [ class "main-content", style style', key url ] content'


computeMargin : Int -> Time -> Int
computeMargin height time =
    time
        |> ease Easing.easeInOutExpo float 0 (toFloat height) duration
        |> round
