module Plot.Plot.Pile exposing (..)

{-|
 The `pile` groups your bar series together and you can also
 add some attributes to alter the view of the bars.

    myBarsSerie : Plot.Element (Interaction YourMsg)
    myBarsSerie =
        pile
            [ Pile.maxBarWidthPer 85 ]
            [ Pile.bars
                [ Bars.fill Common.pinkFill ]
                data
            ]

# Definition
@docs Element, Attribute

# Elements
@docs bars

# Styling
@docs maxBarWidth, maxBarWidthPer


-}

import Svg
import Plot.Plot.Bars as Bars
import Plot.Internal.Bars as BarsInternal
import Plot.Internal.Pile as Internal
import Plot.Internal.Types exposing (Style, Point, Orientation(..), MaxWidth(..))


{-| -}
type alias Attribute =
    Internal.Config -> Internal.Config


{-| -}
type alias Element msg =
    Internal.Element msg


{-| Set a fixed max width (in pixels) on your bars.
-}
maxBarWidth : Int -> Attribute
maxBarWidth max config =
    { config | maxWidth = Fixed max }


{-| Set a relative max width (in percentage) your bars.
-}
maxBarWidthPer : Int -> Attribute
maxBarWidthPer max config =
    { config | maxWidth = Percentage max }


{-| Add a bar series.
-}
bars : List (Bars.Attribute msg) -> List Point -> Element msg
bars attrs points =
    Internal.Bars (List.foldr (<|) BarsInternal.defaultConfig attrs) points
