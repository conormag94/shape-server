{-# LANGUAGE OverloadedStrings #-}

module Convert(convert) where

import Shapes
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as Attr
import qualified Text.Blaze.Html.Renderer.Text as R

import           Text.Blaze.Svg11 ((!), mkPath, rotate, l, m)
import           Text.Blaze.Svg.Renderer.String (renderSvg)
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import qualified Text.Blaze.Svg as Z


convert :: Drawing -> S.Svg
convert x = S.svg ! A.version "1.1" ! A.width "800" ! A.height "800" $ do
    convertShapes x

convertShapes :: Drawing -> S.Svg
convertShapes [x] = parseShape x
convertShapes (x:xs) = parseShape x >> convertShapes xs

-- Without the non-scaling-stroke atrribute, the stroke takes up the whole Shape
parseShape :: (Transform, Shape, Style) -> S.Svg
parseShape (tr, Square, st) = applyAttributes (S.rect ! A.x "0" ! A.y "0" ! A.width "1" ! A.height "1" !
  H.customAttribute "vector-effect" "non-scaling-stroke") (st, tr)
parseShape (tr, Circle, st) = applyAttributes (S.circle ! A.cx "0" ! A.cy "0" ! A.r "1" ! 
  H.customAttribute "vector-effect" "non-scaling-stroke") (st, tr)

applyAttributes :: S.Svg -> (Style, Transform) -> S.Svg
applyAttributes svg (st, tr) = applyStyle (applyTransform svg tr) st

applyTransform :: S.Svg -> Transform -> S.Svg
applyTransform svg Identity = svg
applyTransform svg (Scale (Vector x y)) = svg ! A.transform (Z.scale x y)
applyTransform svg (Translate (Vector x y)) = svg ! A.transform (Z.translate x y)

applyStyle :: S.Svg -> Style -> S.Svg
applyStyle svg (Style fillCol strCol strW) =
  svg ! A.fill (colourToAttr fillCol) ! A.stroke (colourToAttr strCol) ! A.strokeWidth (doubleToAttr strW)


-- Blaze needs attributes in the S.AttributeValue type
colourToAttr :: Colour -> S.AttributeValue
colourToAttr col = S.stringValue (show col)

doubleToAttr :: Double -> S.AttributeValue
doubleToAttr dub = S.stringValue (show dub)
