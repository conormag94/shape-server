{-# LANGUAGE OverloadedStrings #-}
import           Web.Scotty

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as Attr
import qualified Text.Blaze.Html.Renderer.Text as R
import           Text.Blaze.Svg11 ((!), mkPath, rotate, l, m)
import           Text.Blaze.Svg.Renderer.String (renderSvg)
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import           Data.Text.Internal.Lazy
import qualified Data.List.Split as Spl

import Convert
import Shapes

--
--Helpful links:
--
--https://sarasoueidan.com/blog/svg-coordinate-systems/
--https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Basic_Shapes
--https://developer.mozilla.org/en/docs/Web/SVG/Attribute/transform
--http://stackoverflow.com/questions/19484707/how-can-i-make-an-svg-scale-with-its-parent-container

main = scotty 3000 $ do
  get "/" $ do
    html "Hello World"

  get "/sample" $ do
    html $ R.renderHtml $ do
      H.head $ H.title "SVG Shape Server"
      H.body $ do
        H.h1 "Your SVG:"
        convert [(scale (point 50 50), square, (Style Blue Green 5))]
        H.br
        H.b "Unfortunately, submitting this will break the program."
        H.p "The submitted string does not get read back into the Drawing type properly, even if left unchanged"
        H.form ! Attr.action "createSvg" ! Attr.method "post" $ do
          H.input ! Attr.name "shapeDesc" ! Attr.type_ "text" ! Attr.value "[(scale (point 50 50), square, (Style Blue Green 5))]" ! Attr.size "100"
          H.input ! Attr.type_ "submit" ! Attr.value "Submit"

  --Does not work.
  --Gives an error "Prelude.read: no parse"
  --There may be a Read instance somewhere down the chain that gives back an empty value
  post "/createSvg" $ do
    shapeDesc <- param "shapeDesc"
    html $ R.renderHtml $ do
      H.head $ H.title "SVG Shape Server"
      H.body $ do
        H.h1 "Your SVG:"
        convert (read shapeDesc :: [(Transform, Shape, Style)])
        H.br
        H.form ! Attr.action "createSvg" ! Attr.method "post" $ do
          H.input ! Attr.name "shapeDesc" ! Attr.type_ "text" ! Attr.value (S.stringValue shapeDesc) ! Attr.size "300"
          H.input ! Attr.type_ "submit" ! Attr.value "Submit"
