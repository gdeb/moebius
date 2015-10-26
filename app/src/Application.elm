module Application where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Html.Events exposing (onClick)

import Time exposing (Time)
import Easing exposing (ease, float)
import Effects exposing (Effects, Never)

import Animation exposing (..)
import Core exposing (..)
import Components

duration: Float
duration = Time.second*0.4


-- model
type alias Model =
    { route: Route
    , context: Context
    , animation: Maybe (Animation Description)
    , drawerMaxHeight: Int
    }



type Description
    = RouteTransition Route
    | OpenDrawer
    | CloseDrawer



init: Route -> Context -> (Model, Effects Action)
init initRoute initContext =
    noFx
        { route = initRoute
        , context = initContext
        , animation = Nothing
        , drawerMaxHeight = 0
        }

-- update

type Action
    = UpdateRoute Route
    | UpdateContext Context
    | StartAnimation Description Time
    | ToggleDrawer
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

            else if model.context.layout == Mobile then
                noFx { model | route <- route, drawerMaxHeight <- 0 }

            else
                withFx (StartAnimation (RouteTransition route)) model

        UpdateContext context ->
            noFx { model | context <- context }

        ToggleDrawer ->
            if model.drawerMaxHeight == 0 then
                withFx (StartAnimation OpenDrawer) model
            else
                withFx (StartAnimation CloseDrawer) model

        StartAnimation description clockTime ->
            let
                animation = Animation clockTime 0 duration description
            in
                withFx Tick { model | animation <- Just animation }

        Tick clockTime ->
            case model.animation of
                Just animation ->
                    { model | animation <- tick animation clockTime }
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

            OpenDrawer ->
                let
                    newHeight =
                        ease Easing.easeOutBounce float 0 200 1 ratio
                in
                    { model | drawerMaxHeight <- (round newHeight) }

            CloseDrawer ->
                let
                    newHeight =
                        ease Easing.easeInOutExpo float 0 200 1 (1 - ratio)
                in
                    { model | drawerMaxHeight <- (round newHeight) }



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
                [Components.sidebar model.route.url]
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

                    OpenDrawer ->
                        basicRender address model sidebar content

                    CloseDrawer ->
                        basicRender address model sidebar content


            Nothing ->
                basicRender address model sidebar content


basicRender : Signal.Address Action -> Model -> List Html -> List Html -> Html
basicRender address model sidebar content =
    case model.context.layout of
        Mobile ->
            div [class "mobile" ] ((Components.navbar (onClick address ToggleDrawer) model.route.view.title) :: (Components.drawer model.drawerMaxHeight) :: content)

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
