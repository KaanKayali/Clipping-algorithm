# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen. <br />

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. <br />

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.<br />

Clipping can be done with a few mathematical equations, which are explained in this file.

## How it works
The way it works is not as difficult as it seems. There can be many different triangles that need to go through the same process. Usually all 3 vertices of a triangle have their own id and their own x and y coordinates. At this point, all their data should be given before clipping.<br />
<img height="200px" src="/images/screenshot5.png"/>
<img height="200px" src="/images/screenshot8.png"/> 

In pseudocode, each vertex/point of a triangle is checked to see if it is inside or outside any boundary. A simple for-loop can store points inside and outside triangles. This gives four cases:<br />

1. Each vertex is inside the screen. In this case, the whole triangle is rendered.<br />
2. Each vertex is outside the screen. In this case, the whole triangle is removed.<br />
3. Two vertexes are inside of the screen. In this case, this triangle needs to get clipped. It returns a quad. In other words: **two** new triangles.<br />
4. Only a single vertex is inside the screen. In this case, this triangle needs to get clipped. It returns **one** new triangle.<br />

<img width="600px" src="/images/screenshot2.png"/> <br />
<img width="600px" src="/images/screenshot6.png"/> <br />


