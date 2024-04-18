# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen. <br />

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. <br />

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.<br />

Clipping can be done with a few mathematical equations, which are explained in this file.
<br />

## How it works
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

## How to implement
Even though we know how the process works, we still don't know exactly how clipping works. Although it is clear how the process works, it is not yet clear exactly how the clipping works. In order to implement it, it is necessary to check at each edge which case the triangle applies to. It must be handled differently on each case. So the first step is to count the points that are inside and count those that are outside. How many are on the outside is actually the number of points on the inside subtracted from three. Each triangle has 3 points.
Since we would have to query the same thing for each of the 3 points **(0, 1, 2)**, the points that are inside are temporarily stored in a separate list and the points that are outside are temporarily stored in a separate list. This makes it easier to work with the coordinates of each point. This short process can be seen in the script and will be demonstrated later in an example code. 
As the first two cases show the triangle completely or not at all, this is easier to handle and will be ignored here for the time being.<br />
<br />
<img height="250px" src="/images/screenshot21.png"/> <br />
<br />
Clipping means that we take two new calculated coordinates and connect the inner points to these new calculated points instead of the outer points.
These are calculated using [linear interpolation](#linear-interpolation).<br />
<br />
Let's look at the cases where only one or two points of the triangle lie within the screen.<br />
<br />
### 1 Vertex inside
1 Vertex inside means 2 vertexes outside. 
If there is only 1 point inside the screen, we calculate 2 new points that are just on the edge of the screen, so we form a new triangle with them.
The point which is inside can be taken over. The remaining points are ignored after the new two are calculated using linear interpolation.<br />
<img height="200px" src="/images/screenshot19.png"/> <img height="200px" src="/images/screenshot7.png"/> <br />
<br />
Calculation in practice:<br />
<img height="250px" src="/images/screenshot10.png"/><br />
<br />
### 2 Vertexes inside
2 Vertex inside means 1 vertex outside. 
If there are two points inside of the screen, we calculate 2 new points that are just on the edge of the screen, so we form a new quad with them. Since each shape is divided into triangles, the quad is divided into two triangles.
The two points which are inside can be taken over. The remaining point can be ignored after the new two are calculated.<br />
<img height="250px" src="/images/screenshot20.png"/><br />
<br />
Calculation in practice:<br />
<img height="250px" src="/images/screenshot11.png"/><br />
<br />

When this is done, we get back a triangle with new points, which we can use to replace the original triangle when drawing the triangles.
Following my recommendation, we have two lists. The first list contains all the triads as a struct, array or separate list with the 3 dots. The second list is filled with each triangle that has gone through the clipping process. So at the end of all the calculations of each triangle, the second list contains all the triangles that are now on the image.

## Linear interpolation
To calculate the vertex on the edge we should have both of the connecting points inside and outside the border. The point on the edge already has either the x or the y value, based on the border it lies on.
For example, if it is at the right or left edge, the x component is either the screen width or 0 (assuming the origin 0/0 is at the top or bottom right).
The line connecting the first two points is similar to the line that would connect the new points. A simple equation can therefore be created using similarity. The horizontal length of the two points can be calculated using the x values of the inner and outer points. Do the same with the y values for the vertical length. Now we can do the same with the same point on the inside and the point on the edge, where we only know either the x or the y value. In this case, the value is the width of the screen, since we are working with the right edge in this example. However, as we do not know the y value, it is the only value that is unknown and the variable remains.<br />
<img height="200px" src="/images/screenshot13.png"/> <br />
<br />
In vertical examples the new vertex is either 0 or the value of the screen height. So in clipping the other variable is the value to calculate in every case.<br />
<img height="250px" src="/images/screenshot12.png"/> <br />
<br />
Similarity can now be used to equate the two calculated values. For example, the horizontal length between the first original points divided by the vertical length between the first original points equals the horizontal length between the inner point and the point to be recalculated divided by the vertical length between the inner point and the point to be recalculated.<br />
<img height="250px" src="/images/screenshot14.png"/> <br />

Now we solve for the unknown y-value and we have the equation to calculate the new vertex point exactly. In this way every point on the edge can be calculated. With this equation the hardest part is done and it can now only be reused for clipping.<br />
<img height="250px" src="/images/screenshot15.png"/> <br />

Theoretically, in the case of a vertex inside, it looks something like this when calculating the point:
<img height="250px" src="/images/screenshot9.png"/> <br />
<br />

## Code
The clipping-algorithm itself is just in the function. Gamemaker behandelt Arrays wie C# Listen. Sie sind beliebig vergrösser oder verkleinerbar je nach Anzahl gegebenen Werten. Ein Dreieck kann als Objekt, als Struct, als Array (Skalierbar) oder als Liste gespeichert werden.
Jedes Dreieck hat genau 3 Punkte, somit 3 x und y Werte. Ein Beispieldreieck in meinem Code sieht so aus:
```
//Array in gamemaker
exampletriangle = [
	[300, 300],
	[700, 500],
	[200, 600],
];
```
Als struct würde es übersehlicher sein, aber bei der Benutzung eines Structes ist es nicht möglich in Gamemaker durch die Werte durch zu loopen:
```
//Struct
exampletriangle = {
	point0 : {
		x : 300,
		y : 300
	},
	point1 : {
		x : 700,
		y : 500
	},
	point2 : {
		x : 200,
		y : 600
	},
	
};

```

<img height="250px" src="/images/screenshot16.png"/> <br />
<img height="250px" src="/images/screenshot17.png"/> <br />
