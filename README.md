# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen. <br />

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. <br />

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.<br />

Clipping can be done with a few mathematical equations, which are explained in this file.
<br />

# How it works
The way it works is not as difficult as it seems. There can be many different triangles that need to go through the same process. Usually all 3 vertices of a triangle have their own id and their own x and y coordinates. At this point, all their data should be given before clipping.<br />
<img height="200px" src="/images/screenshot5.png"/>
<img height="200px" src="/images/screenshot8.png"/> 
<br />

## Pseudocode
```
Create trianglelist
Create renderTrianglelist

Loop through trianglelist
	For each Triangle -> Check triangle points:
		Create 4 temporary trianglelist for each border
		For each border:
			If 3 are outside
				Do nothing
			If 0 are outside: 
				Push entire triangle to the right trianglelist
			If 1 are outside:
				Form quad = Calculate 2 new points
				Push 2 new triangles to the right trianglelist
			If 2 are outside:
				Form triangle = Calculate 2 new points
				Push 1 new triangle to the right trianglelist
		Add every value from LAST temporary trianglelist to renderTrianglelist
		Empty temporary trianglelist
```
		

In pseudocode, each vertex/point of a triangle is checked to see if it is inside or outside any boundary. A simple for-loop can store points inside and outside triangles. This gives four cases:<br />
* **3** points is inside the screen. In this case, the whole triangle is rendered.<br />
* **0** points is inside the screen. In this case, the whole triangle is removed.<br />
* **2** points are inside of the screen. In this case, this triangle needs to get clipped. It returns a quad. In other words: **two** new triangles.<br />
* **1** point is inside the screen. In this case, this triangle needs to get clipped. It returns **one** new triangle.<br />

<img width="600px" src="/images/screenshot2.png"/> <br />
<img width="600px" src="/images/screenshot6.png"/> <br />

This sounds simple enough. But what if a single triangle is so large that it applies to multiple cases at once.<br />
To address this issue, we repeat the clipping process for every triangle that remains after the initial clipping. The order in which we cut the edges of a triangle is key here. After clipping at one border, each resulting triangle goes through the same process at the next border. This continues until all borders have been processed. By doing this, we end up with a new set of triangles that should be rendered, improving how we determine which ones are visible on the screen.<br />
<br />
<img height="250px" src="/images/screenshot3.png"/> <br />
<img height="250px" src="/images/screenshot4.png"/> <br />
In this example we end up with 8 triangles that need to be drawn.
<br />

# How to implement
Even though we know how the process works, we still don't know exactly how clipping works. Although it is clear how the process works, it is not yet clear exactly how the clipping works. In order to implement it, it is necessary to check at each edge which case the triangle applies to. It must be handled differently on each case. So the first step is to count the points that are inside and count those that are outside. How many are on the outside is actually the number of points on the inside subtracted from three. Each triangle has 3 points.
Since we would have to query the same thing for each of the 3 points **(0, 1, 2)**, the points that are inside are temporarily stored in a separate list and the points that are outside are temporarily stored in a separate list. This makes it easier to work with the coordinates of each point. This short process can be seen in the script and will be demonstrated later in an example code. 
As the first two cases show the triangle completely or not at all, this is easier to handle and will be ignored here for the time being.<br />
<br />
<img height="250px" src="/images/screenshot21.png"/> <br />
Clipping means that we take two new calculated coordinates and connect the inner points to these new calculated points instead of the outer points.
These are calculated using [linear interpolation](#linear-interpolation)

<br />
Let's look at the cases where only one or two points of the triangle lie within the screen.

## 1 Vertex inside
1 Vertex inside means 2 vertexes outside. 
If there is only 1 point inside the screen, we calculate 2 new points that are just on the edge of the screen, so we form a new triangle with them.
The point which is inside can be taken over. The remaining points are ignored after the new two are calculated.
<img height="250px" src="/images/screenshot19.png"/> <br />

## 2 Vertexes inside
2 Vertex inside means 1 vertex outside. 
If there are two points inside of the screen, we calculate 2 new points that are just on the edge of the screen, so we form a new quad with them. Since each shape is divided into triangles, the quad is divided into two triangles.
The two points which are inside can be taken over. The remaining point can be ignored after the new two are calculated.
<img height="250px" src="/images/screenshot20.png"/> <br />

# Linear interpolation
