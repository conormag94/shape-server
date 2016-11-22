module Shapes(
  Shape(..), Point(..), Vector(..), Transform(..), Colour(..), Style(..), Drawing(..),
  point, getX, getY,
  empty, circle, square,
  identity, translate, rotate, scale, (<+>))
  where
  -- inside, borders, distance)  where


-- Utilities

data Vector = Vector Double Double
              deriving (Read, Show)
vector = Vector

cross :: Vector -> Vector -> Double
cross (Vector a b) (Vector a' b') = a * a' + b * b'

mult :: Matrix -> Vector -> Vector
mult (Matrix r0 r1) v = Vector (cross r0 v) (cross r1 v)

invert :: Matrix -> Matrix
invert (Matrix (Vector a b) (Vector c d)) = matrix (d / k) (-b / k) (-c / k) (a / k)
  where k = a * d - b * c

-- 2x2 square matrices are all we need.
data Matrix = Matrix Vector Vector
              deriving (Read, Show)

matrix :: Double -> Double -> Double -> Double -> Matrix
matrix a b c d = Matrix (Vector a b) (Vector c d)

getX (Vector x y) = x
getY (Vector x y) = y

-- Shapes

type Point  = Vector

point :: Double -> Double -> Point
point = vector


data Shape = Empty
           | Circle
           | Square
             deriving (Read, Show)

empty, circle, square :: Shape

empty = Empty
circle = Circle
square = Square

-- Transformations

data Transform = Identity
           | Translate Vector
           | Scale Vector
           | Compose Transform Transform
           | Rotate Matrix
             deriving (Read, Show)

identity = Identity
translate = Translate
scale = Scale
rotate angle = Rotate $ matrix (cos angle) (-sin angle) (sin angle) (cos angle)
t0 <+> t1 = Compose t0 t1

transform :: Transform -> Point -> Point
transform Identity                   x = id x
transform (Translate (Vector tx ty)) (Vector px py)  = Vector (px - tx) (py - ty)
transform (Scale (Vector tx ty))     (Vector px py)  = Vector (px / tx)  (py / ty)
transform (Rotate m)                 p = (invert m) `mult` p
transform (Compose t1 t2)            p = transform t2 $ transform t1 p

data Colour = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White
  deriving (Eq,Enum,Read)

black, red, green, yellow, blue, magenta, cyan, white :: Colour
black = Black
red = Red
green = Green
yellow = Yellow
blue = Blue
magenta = Magenta
cyan = Cyan
white = White

instance Show Colour where
  show Black = "black"
  show Red = "red"
  show Green = "green"
  show Yellow = "yellow"
  show Blue = "blue"
  show Magenta = "Magenta"
  show Cyan = "cyan"
  show White = "white"


-- FillColour, StrokeColour, StrokeWidth
data Style = Style Colour Colour Double
  deriving (Read, Show)

style = Style
-- Drawings

type Drawing = [(Transform, Shape, Style)]
