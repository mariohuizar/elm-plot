module Plot.Plot.Tick
    exposing
        ( Attribute
        , StyleAttribute
        , view
        , viewDynamic
        , viewCustom
        , stroke
        , strokeWidth
        , opacity
        , classes
        , customAttrs
        , length
        , width
        , values
        , delta
        )

{-|
 Attributes for altering the values and view of your axis' ticks.

 Before you read any further, please note that when I speak of the tick _index_,
 then I'm talking about how many ticks that particular tick is from the origin.

 Ok, now you can go on!

# Definition
@docs Attribute

# Styling
@docs StyleAttribute, view, viewDynamic, viewCustom

## Style attributes
If these attributes do not forfill your needs, try out the `viewCustom`! If you have
a suspicion that I have missed a very common configuration, then please let me know and I'll add it.

@docs classes, width, length, stroke, strokeWidth, opacity, customAttrs

# Values
@docs values, delta

-}

import Svg
import Plot.Internal.Types exposing (Style)
import Plot.Internal.Draw exposing (..)
import Plot.Internal.Tick as Internal
    exposing
        ( Config
        , StyleConfig
        , ValueConfig(..)
        , ViewConfig(..)
        , View
        , defaultConfig
        , defaultStyleConfig
        )


{-| -}
type alias Attribute msg =
    Config msg -> Config msg


{-| -}
type alias StyleAttribute msg =
    StyleConfig msg -> StyleConfig msg


{-| Set the length of the tick (in pixels).

    myYAxis : Plot.Element msg
    myYAxis =
        Plot.yAxis
            [ Axis.tick
                [ Tick.view
                    [ Tick.length 8 ]
                ]
            ]
-}
length : Int -> StyleAttribute msg
length length config =
    { config | length = length }


{-| Set the width of the tick (in pixels).

    myYAxis : Plot.Element msg
    myYAxis =
        Plot.yAxis
            [ Axis.tick
                [ Tick.view
                    [ Tick.width 2 ]
                ]
            ]
-}
width : Int -> StyleAttribute msg
width width config =
    { config | width = width }


{-| Add classes to the tick.

    myYAxis : Plot.Element msg
    myYAxis =
        Plot.yAxis
            [ Axis.tick
                [ Tick.view
                    [ Tick.classes [ "my-tick" ] ]
                ]
            ]
-}
classes : List String -> StyleAttribute msg
classes classes config =
    { config | classes = classes }


{-| Set the stroke color.
-}
stroke : String -> StyleAttribute msg
stroke stroke config =
    { config | style = ( "stroke", stroke ) :: config.style }


{-| Set the stroke width (in pixels).
-}
strokeWidth : Int -> StyleAttribute msg
strokeWidth strokeWidth config =
    { config | style = ( "stroke-width", toPixelsInt strokeWidth ) :: config.style }


{-| Set the opacity.
-}
opacity : Float -> StyleAttribute msg
opacity opacity config =
    { config | style = ( "opacity", toString opacity ) :: config.style }


{-| Add your own attributes. For events, see [this example](https://github.com/terezka/elm-plot/blob/master/examples/Interactive.elm)
-}
customAttrs : List (Svg.Attribute msg) -> StyleAttribute msg
customAttrs attrs config =
    { config | customAttrs = attrs }


toStyleConfig : List (StyleAttribute msg) -> StyleConfig msg
toStyleConfig attributes =
    List.foldl (<|) defaultStyleConfig attributes


{-| Provide a list of style attributes to alter the view of the tick.

    myYAxis : Plot.Element msg
    myYAxis =
        Plot.yAxis
            [ Axis.tick
                [ Tick.view
                    [ Tick.style
                        [ ( "stroke", "deeppink" ) ]
                    , Tick.length 5
                    , Tick.width 2
                    ]
                ]
            ]

 **Note:** If you add another attribute msgltering the view like `viewDynamic` or `viewCustom` _after_ this attribute,
 then this attribute will have no effect.
-}
view : List (StyleAttribute msg) -> Attribute msg
view styles config =
    { config | viewConfig = FromStyle (toStyleConfig styles) }


{-| Alter the view of the tick based on the tick's value and index (amount of ticks from origin) by
 providing a function returning a list of style attributes.

    toTickStyles : ( Int, Float ) -> List Tick.StyleAttribute
    toTickStyles ( index, value ) =
        if isOdd index then
            [ Tick.length 7
            , Tick.style [ ( "stroke", "#e4e3e3" ) ]
            ]
        else
            [ Tick.length 10
            , Tick.style [ ( "stroke", "#b9b9b9" ) ]
            ]

    myYAxis : Plot.Element msg
    myYAxis =
        Plot.yAxis
            [ Axis.tick
                [ Tick.viewDynamic toTickStyles ]
            ]

 **Note:** If you add another attribute msgltering the view like `view` or `viewCustom` _after_ this attribute,
 then this attribute will have no effect.
-}
viewDynamic : (( Int, Float ) -> List (StyleAttribute msg)) -> Attribute msg
viewDynamic toStyles config =
    { config | viewConfig = FromStyleDynamic (toStyleConfig << toStyles) }


{-| Define your own view for the labels. Your view will be passed label's value and index (amount of ticks from origin).

    viewTick : ( Int, Float ) -> Svg.Svg a
    viewTick ( index, tick ) =
        text_
            [ transform "translate(-5, 10)"
            , Svg.Events.onClick (Custom MyTickClickMsg)
            ]
            [ tspan
                []
                [ text (if isOdd index then "🌟" else "⭐") ]
            ]

    myXAxis : Plot.Element msg
    myXAxis =
        Plot.xAxis
            [ Axis.tick
                [ Tick.viewCustom viewTick ]
            ]

 **Note:** If you add another attribute msgltering the view like `view` or `viewDynamic` _after_ this attribute,
 then this attribute will have no effect.
-}
viewCustom : (( Int, Float ) -> Svg.Svg msg) -> Attribute msg
viewCustom view config =
    { config | viewConfig = FromCustomView (always view) }


{-| Specify what values will be added a tick.

    myXAxis : Plot.Element msg
    myXAxis =
        Plot.xAxis
            [ Axis.tick
                [ Tick.values [ 0, 1, 2, 4, 8 ] ]
            ]

 **Note:** If you add another attribute msgltering the values like `delta` _after_ this attribute,
 then this attribute will have no effect.
-}
values : List Float -> Attribute msg
values values config =
    { config | valueConfig = FromCustom values }


{-| Specify what values will be added a tick by specifying the space between each tick.

    myXAxis : Plot.Element msg
    myXAxis =
        Plot.xAxis
            [ Axis.tick
                [ Tick.delta 4 ]
            ]

 **Note:** If you add another attribute msgltering the values like `values` _after_ this attribute,
 then this attribute will have no effect.
-}
delta : Float -> Attribute msg
delta delta config =
    { config | valueConfig = FromDelta delta }
