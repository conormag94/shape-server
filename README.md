# CS4012 Lab 1 - shape server

To run the project:

`$ stack build`

`$ stack exec shape-server-exe`

It will run on the localhost:3000

An example Shape DSL to SVG conversion go to:

`http://localhost:3000/sample`

My aim to allow the user to create a new svg was for them to use the input form to submit a `post /newSvg` but this does not work.

The shape string from this form does not correctly read into the Drawing datatype for some reason. 
It results in an error: `Prelude.read: no parse` which causes no data to be submitted to `localhost:3000/newSvg`, and therefore no new SVG is created.

#### Files Summary

- `Shapes.hs`: Slightly modified from the original. `Drawing` is now `[(Transform, Shape, Style)]`.
- `Convert.hs`: Exports a function `convert` which takes a `Drawing` and gives back a `Svg` from `Text.Blaze.Svg11`.
- `Main.hs`: Routes the urls and calls `convert`, rendering the SVG to the browser using Blaze.
