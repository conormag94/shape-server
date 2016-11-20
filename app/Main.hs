{-# LANGUAGE OverloadedStrings #-}
import           Web.Scotty

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as Attr
import qualified Text.Blaze.Html.Renderer.Text as R
import           Text.Blaze.Svg11 ((!), mkPath, rotate, l, m)
import           Text.Blaze.Svg.Renderer.String (renderSvg)
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A

import Convert
import Shapes

--Links
--https://sarasoueidan.com/blog/svg-coordinate-systems/
--https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Basic_Shapes
--https://developer.mozilla.org/en/docs/Web/SVG/Attribute/transform
--http://stackoverflow.com/questions/19484707/how-can-i-make-an-svg-scale-with-its-parent-container

--Example
--[(scale (point 0.5 0.5) <+> translate (point 1.2 0.4), square)]
--

main = scotty 3000 $ do
  get "/" $ do
    html "Hello World"

  get "/sample" $ do
    html $ sampleSvg

  -- get "/:input" $ do
  --   input <- param "input"
  --   html $ input

sampleSvg = do
  R.renderHtml $ do
    H.head $ H.title "Sample SVG Page"
    H.body $ do
      H.h1 "Sample SVG"
      svgDoc

svgDoc = convert [(scale (point 50 50), square, (Style Blue Green 5))]
