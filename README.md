# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen.

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. 

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.

Clipping can be done with a few mathematical equations, which are explained in this file.

## How it works
