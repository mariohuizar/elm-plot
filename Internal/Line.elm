module Plot.Internal.Line exposing (..)

import Svg
import Svg.Attributes
import Plot.Internal.Types exposing (..)
import Plot.Internal.Draw exposing (..)


type alias Config a =
    { style : Style
    , customAttrs : List (Svg.Attribute a)
    }


defaultConfig : Config a
defaultConfig =
    { style = [ ( "fill", "transparent" ) ]
    , customAttrs = []
    }


view : Meta -> Config a -> List Point -> Svg.Svg a
view { toSvgCoords } { style, customAttrs } points =
    let
        svgPoints =
            List.map toSvgCoords points

        ( startInstruction, _ ) =
            startPath svgPoints

        instructions =
            coordsToInstruction "L" svgPoints

        attrs =
            (stdAttributes (startInstruction ++ instructions) style) ++ customAttrs
    in
        Svg.path attrs []


stdAttributes : String -> Style -> List (Svg.Attribute a)
stdAttributes d style =
    [ Svg.Attributes.d d
    , Svg.Attributes.style (toStyle style)
    , Svg.Attributes.class "elm-plot__serie--line"
    ]
