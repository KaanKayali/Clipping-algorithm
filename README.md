# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen. <br />

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. <br />

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.<br />

Clipping can be done with a few mathematical equations, which are explained in this file.

## How it works
The way it works is not as difficult at it seems. There may be many different triangles which need to go through the same process. Usually every vertex of triangle has its own id and its own x and y coordinate. At this time all of its data should be given before clipping.<br />
<img height="200px" src="/images/screenshot5.png"/>
<img height="200px" src="/images/screenshot8.png"/> 

In pseudocode each vertex/point of a triangle gets checked if its inside or outside of any border. That means with a simple for-loop which loops thorugh every triangle we can store the points which are outside into one list and the points which are on the inside into another list. This way we get as a result the following 4 cases:

1. Case
<img height="300px" src="/images/screenshot18.png"/> 
