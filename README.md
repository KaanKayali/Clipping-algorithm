# Clipping-algorithm
This is a script that cuts a shape out of triangles at the edges of a screen by linear interpolation. It is written in Gamemaker language, but can be easily converted to any language.
Clipping a triangle is common in 2D or even 3D engines. Its purpose is to limit the number of triangles a program has to render. Performance can be improved by avoiding drawing triangles outside the main screen. The amount of calculations that each triangle has to go through is quite high, so it can be quite useful to reduce the number of triangles to those that are visible on your screen. <br />

<img height="300px" src="/images/screenshot18.png"/> 
In this example, the function clipping a single triangle returns 2 new triangles, which takes a bit more performance than just returning the single triangle. But if you are working with e.g. 1000 or more triangles and you want to render them all at the same time, clipping can reduce the amount by a really big number. <br />

If you are working with a 3D engine, most of this is already done for you, but if you are creating your own engine, it is almost impossible to avoid this process.<br />

Clipping can be done with a few mathematical equations, which are explained in this file.
<br />

## How it works
The way it works is not as difficult as it seems. There can be many different triangles that need to go through the same process. Usually all 3 vertices of a triangle have their own id and their own `x` and `y` coordinates. At this point, all their data should be given before clipping.<br />
<br />
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
<br />
<img height="250px" src="/images/screenshot20.png"/><br />
<br />
Calculation in practice:<br />
<br />
<img height="250px" src="/images/screenshot11.png"/><br />
<br />

When this is done, we get back a triangle with new points, which we can use to replace the original triangle when drawing the triangles.
Following my recommendation, we have two lists. The first list contains all the triads as a struct, array or separate list with the 3 dots. The second list is filled with each triangle that has gone through the clipping process. So at the end of all the calculations of each triangle, the second list contains all the triangles that are now on the image.

But there is still a problem. Each triangle has 3 points with different IDs. The points are always addressed by their IDs. So what if it is not exactly point 1 and point 2 that are out, but the point with ID 0? You would have to check whether the points can be clipped individually for each scenario. This is very cumbersome, but can be easily avoided by not enumerating a simple integer when a vertex is inside or outside. They can also be scalable arrays or lists in which the points themselves are added. Then the number of points inside or outside is the length of the arrays or lists. When clipping, you simply use the points from these arrays and lists and not from the original arrays or lists. For example, you can first cache the `insidePoints` and `outsidePoints` arrays. Then add the point with the ID 2 into `insidePoints` as a whole and the other two outside points with the IDs 0 and 1 into `outsidePoints`. Now you have assigned exactly the points that are inside and outside and you no longer have to work with the IDs but can calculate more easily with the values directly from `insidePoints` and `outsidePoints`. This is also how it was solved in my example script.

## Linear interpolation
To calculate the vertex on the edge we should have both of the connecting points inside and outside the border. The point on the edge already has either the `x` or the `y` value, based on the border it lies on.
For example, if it is at the right or left edge, the `x` component is either the screen width or 0 (assuming the origin 0/0 is at the top or bottom right).
The line connecting the first two points is similar to the line that would connect the new points. A simple equation can therefore be created using similarity. The horizontal length of the two points can be calculated using the `x` values of the inner and outer points. Do the same with the `y` values for the vertical length. Now we can do the same with the same point on the inside and the point on the edge, where we only know either the `x` or the `y` value. In this case, the value is the width of the screen, since we are working with the right edge in this example. However, as we do not know the `y` value, it is the only value that is unknown and the variable remains.<br />
<br />
<img height="200px" src="/images/screenshot13.png"/> <br />
<br />
In vertical examples the new vertex is either 0 or the value of the screen height. So in clipping the other variable is the value to calculate in every case.<br />
<br />
<img height="250px" src="/images/screenshot12.png"/> <br />
<br />
Similarity can now be used to equate the two calculated values. For example, the horizontal length between the first original points divided by the vertical length between the first original points equals the horizontal length between the inner point and the point to be recalculated divided by the vertical length between the inner point and the point to be recalculated.<br />
<br />
<img height="250px" src="/images/screenshot14.png"/> <br />

Now we solve for the unknown y-value and we have the equation to calculate the new vertex point exactly. In this way every point on the edge can be calculated. With this equation the hardest part is done and it can now only be reused for clipping.<br />
<br />
<img height="250px" src="/images/screenshot15.png"/> <br />

Theoretically, in the case of a vertex inside, it looks something like this when calculating the point:
<img height="250px" src="/images/screenshot9.png"/> <br />
<br />

As it looks when calculating the point on the vertical, it is exactly the other way round. All x and y values are inverted and instead of the screenwidth it is now the screenheight.

## Code
It is essential to define your border so your program knows where it should clip.
In gamemaker the origin is again at the top left.<br />
screen width: 1280
screen height: 720
<br />
<img height="450px" src="/images/screenshot22.png"/><br />
<br />

The clipping algorithm itself is just in the function. Gamemaker treats arrays like C# lists. They can be enlarged or reduced as required depending on the number of given values. A triangle can be saved as an object, as a struct, as an array (scalable) or as a list.
Each triangle has exactly 3 points, thus 3 `x` and `y` values. A sample triangle in my code looks like this:
```
//Array in gamemaker
exampletriangle = [
	[300, 300],
	[700, 500],
	[200, 600],
];
```
As a struct it would be easier to work with the `x` and `y` values, but when using a struct it is not possible to loop through the values. At least not in Gamemaker:
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

To display many triangles at once, even in shapes, you can either save each triangle as an object and loop through the objects. You can also, as in my example code, store the triangles in a declarable array or list and loop through them. If there are not too many triangles, it is not necessary to loop through them in the code. For each triangle, the clip function is called and stored as a new variable containing the correct triangle, clipped at each edge and ready to display. In my code these are again stored in a new array.

```
//Define variables
displayTriangles = [];
exampletriangle = [
	[300, 300],
	[700, 500],
	[200, 600],
];

array_push(displayTriangles, exampletriangle);

//Clipping list
for(var i = 0; i < array_length(displayTriangles); i++) {
    var clippedTriangles = clipTriangle(displayTriangles[i]); //Clipping progress

    //Into an array/list
    for (var j = 0; j < array_length(clippedTriangles); j++) array_push(renderTriangles, clippedTriangles[j]);

}

//renderTriangles now has every triangle in it. Each triangle has been clipped at this point and is now ready to be rendered
```

All that remains to be programmed is the clipping algorithm itself, which treats each triangle individually in the `clipFunction` function. 
A few new variables and arrays are defined in this function:
```
//Clipp triangle
function clipTriangle(triangle) {
    	var triangleToClip = triangle; 
	var insidePoints = []; //Insidepoints to store every point which is inside the screen
	var outsidePoints = []; //Outsidepoints to store every point which is outside of the screen

	//Temporary arrays in order to store every new triangle after getting clipped
	//For each border one array
	var trianglestolookleft = []; 
	var trianglestolooktop = [];
	var trianglestolookright = [];
	var trianglestolookbottom = [];

	//Clipping...


	//Returning the last array after going through every border
	return trianglestolookbottom;

}
```

It can be confusing to have so many lists or arrays inside each other. To have an overview of how a triangle, a point and the cooridants can be called, here are examples:
<br />
Triangle: `displayTriangles[0] //There could be any number`
Point: `displayTriangles[0][0] //Point with the ID 0 of this specific triangle`
x-value: `displayTriangles[0][0][0] //x-value of the Point with the ID 0`
y-value: `displayTriangles[0][0][1] //y-value of the Point with the ID 0`

The order in which you cut each side of the triangle is up to you. In my example, however, it starts with the left edge, continues with the top edge, continues with the right edge and ends with the bottom edge. So after all the new triangles have been stored in `trianglestolookleft`, this is passed to the top edge to cut all the triangles on top again, and any new or ignored triangles are returned to `trianglestolooktop`. This continues until every triangle at the bottom has been clipped and all new triangles, including those created at the bottom, are finally stored in `trianglestolookbottom', which is why it can now be returned. This last array contains all the triangles that could be generated from this one triangle.

At each edge, the arrays of insidePoints and outsidePoints must be reset in order to reuse them at the new edge. In Gamemaker this works by setting the arrays back to `[]`:
```
insidePoints = [];
outsidePoints = [];
```
<br />

Simple if-statements are needed to check which point is outside a particular boundary:
```
//Left border
if(triangleToClip[0][0] >= 0) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
if(triangleToClip[1][0] >= 0) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
if(triangleToClip[2][0] >= 0) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
```

In this example, it looks at the specific triangle to see if the x values are greater than or equal to 0. This if-statement only works on the left edge because the left edge is at 0 on the x-axis. So if the x-value of the 3 points is greater than or equal to it, it is inside the screen, otherwise it is outside the screen. So the point is added to either `insidePoints` or `outsidePoints`.

To simplify the check, a small length over the outer edge of the screen can be checked to see if it lies within it. This means that we use a second variable to make the entire screen smaller than it is to see whether clipping works. In addition, this value allows us to make the script more changeable. This means that if in the future we decide to reduce or enlarge the size of the screen where the clipping takes place, it can be done easily. In my coding example it looks like this:<br />
<br />
<img height="450px" src="/images/screenshot23.png"/><br />
```
//Variables
buffer = 50;

//Left border
if(triangleToClip[0][0] >= buffer) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
if(triangleToClip[1][0] >= buffer) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
if(triangleToClip[2][0] >= buffer) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
```
If you want to check if it is inside at every border, you need to incooperate the buffer everywhere.<br />
<br />
<img height="450px" src="/images/screenshot24.png"/><br />

You now need to check for every possible scenario a triangle could be in.

* If array_length(insidepoints) = 3 -> Already into the next array

* No need to check if its 0. I wont do anything if it has. The triangle just gets ignored and wont render at all

* If array_length(insidepoints) = 1 -> Form triangle and add the new calculated triangles

* If array_length(insidepoints) = 2 -> Form quad and add 2 new calculated triangles

We have everything we need. We need to add the calculations we learned from [1 Vertex inside](#1-vertex-inside) and [2 Vertexes inside](#2-vertexes-inside).
So in the end it looks like this for the left border:
```
//All points lie on the inside
if(array_length(insidePoints) == 3) array_push(trianglestolookleft, triangleToClip); //Take over the triangle

//Create new small triangle
if(array_length(insidePoints) == 1) && (array_length(outsidePoints) == 2){
	var newpoint0 = insidePoints[0]; //Take over the point that is inside
	var newscr1 = ((buffer - outsidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]); //Linear interpolate
	var newscr2 = ((buffer - outsidePoints[1][0]) * (outsidePoints[1][1] - insidePoints[0][1]))/(outsidePoints[1][0] - insidePoints[0][0]); //Linear interpolate
	var newpoint1 = [buffer, outsidePoints[0][1] + newscr1]; //Calculate the new points which lie right on the border
	var newpoint2 = [buffer, outsidePoints[1][1] + newscr2];

	var newtriangle = [newpoint0, newpoint1, newpoint2]; //Set new triangle with the new points
	array_push(trianglestolookleft, newtriangle); //Add triangle to temporary array to continue this process with the other borders later
}

//Create new quad aka 2 triangles
if(array_length(insidePoints) == 2) && (array_length(outsidePoints) == 1){
	var newpoint0 = insidePoints[0]; //Take over the two points that are inside
	var newpoint1 = insidePoints[1];

	var newscr2 = ((buffer - insidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]); //Linear interpolate
	var newscr3 = ((buffer - insidePoints[1][0]) * (outsidePoints[0][1] - insidePoints[1][1]))/(outsidePoints[0][0] - insidePoints[1][0]); //Linear interpolate

	var newpoint2 = [buffer, insidePoints[0][1] + newscr2]; //Calculate the new points which lie right on the border
	var newpoint3 = [buffer, insidePoints[1][1] + newscr3];

	var newtriangle0 = [newpoint0, newpoint1, newpoint2]; //Set both triangle with the new points
	var newtriangle1 = [newpoint1, newpoint2, newpoint3];
	array_push(trianglestolookleft, newtriangle0); //Add both triangles to temporary array to continue this process with the other borders later
	array_push(trianglestolookleft, newtriangle1);
}

```
The array at the end of this process now needs to be checked for the next edge using the next for loop. <br />
For visualisation, the if-statements on each of the edges look like this:

If the point is after those checks always true, it is inside the screen.<br />
If it is false in one of those, its not.

Left: `if point.x >= buffer` <br />
<img height="250px" src="/images/screenshot25.png"/><br />

Top: `if point.y >= buffer` <br />
<img height="250px" src="/images/screenshot27.png"/><br />

Right: `if point.x <= scrwidth-buffer` <br />
<img height="250px" src="/images/screenshot26.png"/><br />	

Bottom: `if point.y <= scrheight-buffer` <br />
<img height="250px" src="/images/screenshot28.png"/><br />

The temporary arrays such as `trianglestolookleft` do not need to be reset in the function, as the arrays are automatically set to `[]` for each triangle.
When I run my script in gamemaker it looks like this:<br />
<br />
<img height="225px" src="/images/video1.gif"/> <img height="225px" src="/images/video2.gif"/> <br />

When you have finished and tested the function, remember to set your buffer to 0 so that the clipping is not visible to the user.
<br />
<img height="300px" src="/images/screenshot29.png"/> <br />
<br />
You can find the final version of it in the script.<br />
Only if you want to, of course!<br />
I hope this helped.
