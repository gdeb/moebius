module Application where

import Easing exposing (ease, float)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Html.Events exposing (onClick)
import Time exposing (Time)

import Animation exposing (..)
import Components
import Core exposing (..)
import Utils


-- model
type alias Model =
    { route: Route
    , context: Context
    , animation: Maybe (Animation Description)
    , drawerMaxHeight: Int
    }


type Description
    = RouteTransition Route
    | ToggleDrawer Direction


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
    | UpdateDrawer
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

        UpdateDrawer ->
            if model.drawerMaxHeight == 0 then
                withFx (StartAnimation (ToggleDrawer Down)) model
            else
                withFx (StartAnimation (ToggleDrawer Up)) model

        StartAnimation description clockTime ->
            let
                duration = 0.4 * Time.second

                animation = Animation clockTime 0 duration description
            in
                withFx Tick { model | animation <- Just animation }

        Tick clockTime ->
            case model.animation of
                Just animation ->
                    { model | animation <- tick animation clockTime }
                        |> animate animation.description
                        |> dispatchFx Tick

                Nothing ->
                    noFx model


animate : Description -> Model -> Model
animate description model =
    let
        ratio = getRatio model.animation
    in
        case description of
            RouteTransition route ->
                if ratio < 1 then
                    model

                else
                    { model | route <- route }

            ToggleDrawer direction ->
                let
                    newHeight =
                        if direction == Down then
                            ease Easing.easeOutBounce float 0 200 1 ratio
                        else
                            ease Easing.easeInOutExpo float 0 200 1 (1 - ratio)
                in
                    { model | drawerMaxHeight <- round newHeight }


-- view
view : Signal.Address Action -> Model -> Html
view address model =
    let
        content =
            model.route.view.content model.context
    in
        case model.context.layout of
            Mobile ->
                renderMobile address model content

            Desktop ->
                renderDesktop address model content


renderMobile : Signal.Address Action -> Model -> List Html -> Html
renderMobile address model content =
    let
        navbar = Components.navbar (onClick address UpdateDrawer) model.route.view.title

        drawer = if model.drawerMaxHeight == 0 then
                []
            else
                [ Components.drawer model.route.url model.drawerMaxHeight ]

        content' =  navbar :: (drawer ++ content)
    in
        div [class "mobile" ] content'


getInfo : Animation Description -> Maybe (Route, Time, Time)
getInfo animation =
    case animation.description of
        RouteTransition route ->
            Just (route, animation.elapsedTime, animation.duration)

        otherwise ->
            Nothing


renderDesktop : Signal.Address Action -> Model -> List Html -> Html
renderDesktop address model content =
    let
        sidebar =
            if model.route.view.fullScreen then
                []
            else
                [Components.sidebar model.route.url]

        content' =
            case (Maybe.andThen model.animation getInfo) of
                Just (route, elapsedTime, duration) ->
                    let
                        nextContent = route.view.content model.context

                        height = toFloat model.context.height

                        alpha =
                            elapsedTime
                                |> ease Easing.easeInOutExpo float 0 height duration
                                |> round

                        dir =
                            Utils.sign (model.route.sequence - route.sequence)

                    in
                        [ renderContent (dir * alpha) model.route.url content
                        , renderContent (dir*(alpha - model.context.height)) route.url nextContent
                        ]

                Nothing ->
                    [renderContent 0 model.route.url content]

    in
        div [ class "desktop" ] (sidebar ++ content')


renderContent : Int -> String -> List Html -> Html
renderContent margin url content' =
    let style' =
        if margin == 0 then
            []
        else
            [("margin-top", toString margin ++ "px"), ("position", "fixed")]
    in
        div [ class "main-content", style style', key url ] content'


