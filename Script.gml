//Define variables
displayTriangles = [];
exampletriangle = [
	[300, 300],
	[700, 500],
	[200, 600],
];
array_push(displayTriangles, exampletriangle);

//Macros
#macro scrwidth 1280
#macro scrheight 720
#macro buffer 50


//Clipp triangle
function clipTriangle(triangle) {
    var triangleToClip = triangle;
	var insidePoints = [];
	var outsidePoints = [];
	
	var trianglestolookleft = [];
	var trianglestolooktop = [];
	var trianglestolookright = [];
	var trianglestolookbottom = [];
	
	//Left border
	if(triangleToClip[0][0] >= buffer) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
	if(triangleToClip[1][0] >= buffer) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
	if(triangleToClip[2][0] >= buffer) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
	
	//All points lie on the inside
	if(array_length(insidePoints) == 3) array_push(trianglestolookleft, triangleToClip);
	
	//Create new small triangle
	if(array_length(insidePoints) == 1) && (array_length(outsidePoints) == 2){
		var newpoint0 = insidePoints[0];
		var newscr1 = ((buffer - outsidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]);
		var newscr2 = ((buffer - outsidePoints[1][0]) * (outsidePoints[1][1] - insidePoints[0][1]))/(outsidePoints[1][0] - insidePoints[0][0]);
		var newpoint1 = [buffer, outsidePoints[0][1] + newscr1];
		var newpoint2 = [buffer, outsidePoints[1][1] + newscr2];
	
		var newtriangle = [newpoint0, newpoint1, newpoint2];
		array_push(trianglestolookleft, newtriangle);
	}
	
	//Create new quad aka 2 triangles
	if(array_length(insidePoints) == 2) && (array_length(outsidePoints) == 1){
		var newpoint0 = insidePoints[0];
		var newpoint1 = insidePoints[1];
	
		var newscr2 = ((buffer - insidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]);
		var newscr3 = ((buffer - insidePoints[1][0]) * (outsidePoints[0][1] - insidePoints[1][1]))/(outsidePoints[0][0] - insidePoints[1][0]);
	
		var newpoint2 = [buffer, insidePoints[0][1] + newscr2];
		var newpoint3 = [buffer, insidePoints[1][1] + newscr3];
	
		var newtriangle0 = [newpoint0, newpoint1, newpoint2];
		var newtriangle1 = [newpoint1, newpoint2, newpoint3];
		array_push(trianglestolookleft, newtriangle0);
		array_push(trianglestolookleft, newtriangle1);
	}
		
	//Top border
	for(var j = 0; j < array_length(trianglestolookleft); j++){
		triangleToClip = trianglestolookleft[j];
		insidePoints = [];
		outsidePoints = [];
		
		if(triangleToClip[0][1] >= buffer) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
		if(triangleToClip[1][1] >= buffer) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
		if(triangleToClip[2][1] >= buffer) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
	
		//All points lie on the inside
		if(array_length(insidePoints) == 3) array_push(trianglestolooktop, triangleToClip);
	
		//Create new small triangle
		if(array_length(insidePoints) == 1) && (array_length(outsidePoints) == 2){
			var newpoint0 = insidePoints[0];
			var newscr1 = ((buffer - outsidePoints[0][1]) * (outsidePoints[0][0] - insidePoints[0][0]))/(outsidePoints[0][1] - insidePoints[0][1]);
			var newscr2 = ((buffer - outsidePoints[1][1]) * (outsidePoints[1][0] - insidePoints[0][0]))/(outsidePoints[1][1] - insidePoints[0][1]);
			var newpoint1 = [outsidePoints[0][0] + newscr1, buffer];
			var newpoint2 = [outsidePoints[1][0] + newscr2, buffer];
	
			var newtriangle = [newpoint0, newpoint1, newpoint2];
			array_push(trianglestolooktop, newtriangle);
		}
	
		//Create new quad aka 2 triangles
		if(array_length(insidePoints) == 2) && (array_length(outsidePoints) == 1){
			var newpoint0 = insidePoints[0];
			var newpoint1 = insidePoints[1];
	
			var newscr2 = ((buffer - insidePoints[0][1]) * (outsidePoints[0][0] - insidePoints[0][0]))/(outsidePoints[0][1] - insidePoints[0][1]);
			var newscr3 = ((buffer - insidePoints[1][1]) * (outsidePoints[0][0] - insidePoints[1][0]))/(outsidePoints[0][1] - insidePoints[1][1]);
	
			var newpoint2 = [insidePoints[0][0] + newscr2, buffer];
			var newpoint3 = [insidePoints[1][0] + newscr3, buffer];
	
			var newtriangle0 = [newpoint0, newpoint1, newpoint2];
			var newtriangle1 = [newpoint1, newpoint2, newpoint3];
			array_push(trianglestolooktop, newtriangle0);
			array_push(trianglestolooktop, newtriangle1);
		}
	}
	
	//Right border
	for(var j = 0; j < array_length(trianglestolooktop); j++){
		triangleToClip = trianglestolooktop[j];
		insidePoints = [];
		outsidePoints = [];
		
		if(triangleToClip[0][0] <= scrwidth-buffer) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
		if(triangleToClip[1][0] <= scrwidth-buffer) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
		if(triangleToClip[2][0] <= scrwidth-buffer) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
	
		//All points lie on the inside
		if(array_length(insidePoints) == 3) array_push(trianglestolookright, triangleToClip);
	
		//Create new small triangle
		if(array_length(insidePoints) == 1) && (array_length(outsidePoints) == 2){
			var newpoint0 = insidePoints[0];
			var newscr1 = ((scrwidth-buffer - outsidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]);
			var newscr2 = ((scrwidth-buffer - outsidePoints[1][0]) * (outsidePoints[1][1] - insidePoints[0][1]))/(outsidePoints[1][0] - insidePoints[0][0]);
			var newpoint1 = [scrwidth-buffer, outsidePoints[0][1] + newscr1];
			var newpoint2 = [scrwidth-buffer, outsidePoints[1][1] + newscr2];
	
			var newtriangle = [newpoint0, newpoint1, newpoint2];
			array_push(trianglestolookright, newtriangle);
		}
	
		//Create new quad aka 2 triangles
		if(array_length(insidePoints) == 2) && (array_length(outsidePoints) == 1){
			var newpoint0 = insidePoints[0];
			var newpoint1 = insidePoints[1];
	
			var newscr2 = ((scrwidth-buffer - insidePoints[0][0]) * (outsidePoints[0][1] - insidePoints[0][1]))/(outsidePoints[0][0] - insidePoints[0][0]);
			var newscr3 = ((scrwidth-buffer - insidePoints[1][0]) * (outsidePoints[0][1] - insidePoints[1][1]))/(outsidePoints[0][0] - insidePoints[1][0]);
	
			var newpoint2 = [scrwidth-buffer, insidePoints[0][1] + newscr2];
			var newpoint3 = [scrwidth-buffer, insidePoints[1][1] + newscr3];
	
			var newtriangle0 = [newpoint0, newpoint1, newpoint2];
			var newtriangle1 = [newpoint1, newpoint2, newpoint3];
			array_push(trianglestolookright, newtriangle0);
			array_push(trianglestolookright, newtriangle1);
		}
	}
	
	//Bottom border
	for(var j = 0; j < array_length(trianglestolookright); j++){
		triangleToClip = trianglestolookright[j];
		insidePoints = [];
		outsidePoints = [];
		
		if(triangleToClip[0][1] <= scrheight-buffer) array_push(insidePoints, triangleToClip[0]); else array_push(outsidePoints, triangleToClip[0]);
		if(triangleToClip[1][1] <= scrheight-buffer) array_push(insidePoints, triangleToClip[1]); else array_push(outsidePoints, triangleToClip[1]);
		if(triangleToClip[2][1] <= scrheight-buffer) array_push(insidePoints, triangleToClip[2]); else array_push(outsidePoints, triangleToClip[2]);
	
		//All points lie on the inside
		if(array_length(insidePoints) == 3) array_push(trianglestolookbottom, triangleToClip);
	
		//Create new small triangle
		if(array_length(insidePoints) == 1) && (array_length(outsidePoints) == 2){
			var newpoint0 = insidePoints[0];
			var newscr1 = ((scrheight-buffer - outsidePoints[0][1]) * (outsidePoints[0][0] - insidePoints[0][0]))/(outsidePoints[0][1] - insidePoints[0][1]);
			var newscr2 = ((scrheight-buffer - outsidePoints[1][1]) * (outsidePoints[1][0] - insidePoints[0][0]))/(outsidePoints[1][1] - insidePoints[0][1]);
			var newpoint1 = [outsidePoints[0][0] + newscr1, scrheight-buffer];
			var newpoint2 = [outsidePoints[1][0] + newscr2, scrheight-buffer];
	
			var newtriangle = [newpoint0, newpoint1, newpoint2];
			array_push(trianglestolookbottom, newtriangle);
		}
	
		//Create new quad aka 2 triangles
		if(array_length(insidePoints) == 2) && (array_length(outsidePoints) == 1){
			var newpoint0 = insidePoints[0];
			var newpoint1 = insidePoints[1];
	
			var newscr2 = ((scrheight-buffer - insidePoints[0][1]) * (outsidePoints[0][0] - insidePoints[0][0]))/(outsidePoints[0][1] - insidePoints[0][1]);
			var newscr3 = ((scrheight-buffer - insidePoints[1][1]) * (outsidePoints[0][0] - insidePoints[1][0]))/(outsidePoints[0][1] - insidePoints[1][1]);
	
			var newpoint2 = [insidePoints[0][0] + newscr2, scrheight-buffer];
			var newpoint3 = [insidePoints[1][0] + newscr3, scrheight-buffer];
	
			var newtriangle0 = [newpoint0, newpoint1, newpoint2];
			var newtriangle1 = [newpoint1, newpoint2, newpoint3];
			array_push(trianglestolookbottom, newtriangle0);
			array_push(trianglestolookbottom, newtriangle1);
		}
	}
	
    return trianglestolookbottom;
}


//Clipping list
for(var i = 0; i < array_length(displayTriangles); i++) {
    var clippedTriangles = clipTriangle(displayTriangles[i]);

    //Into rendertriangles
    for (var j = 0; j < array_length(clippedTriangles); j++) array_push(renderTriangles, clippedTriangles[j]);
}

