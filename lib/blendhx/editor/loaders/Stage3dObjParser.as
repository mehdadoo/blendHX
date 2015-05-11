// OBJ file format parser for Stage3d - version 2.31
// gratefully adapted from work by Alejandro Santander
//
// A one-file, zero dependencies solution!
// Just drop into your project and enjoy.
//
// This class only does ONE thing:
// it turns an OBJ file into Stage3d buffers.
//
// example:
//
// [Embed (source = "mesh.obj", mimeType = "application/octet-stream")] 
// private var myObjData:Class;
//
// ... set up your transforms, texture, vertex and fragment programs as normal ...
//
// var myMesh:Stage3dObjParser = new Stage3dObjParser(myObjData);
// context3D.setVertexBufferAt(0, myMesh.positionsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
// context3D.setVertexBufferAt(1, myMesh.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
// context3D.drawTriangles(myMesh.indexBuffer, 0, myMesh.indexBufferCount);
//
// [Some older exporters (eg 3dsmax9) format things differently: zxy instead of xyz:]
// [var myMesh:Stage3dObjParser = new Stage3dObjParser(myObjData, 1, true);]
// [Also, some exporters flip the U texture coordinate:]
// [var myMesh:Stage3dObjParser = new Stage3dObjParser(myObjData, 1, true, true);]
//
// Note: no quads allowed!
// If your model isn't working, check that you 
// have triangulated your mesh so each polygon uses
// exactly three vertexes - no more and no less.
//
// No groups or sub-models - one mesh per file.
// No .mat material files are used - geometry only.

package blendhx.editor.loaders
{

import flash.geom.Vector3D;
import flash.geom.Matrix3D;
import flash.utils.ByteArray;

public class Stage3dObjParser
{
// older versions of 3dsmax use an invalid vertex order: 
private var _vertexDataIsZxy:Boolean = false;
// some exporters mirror the UV texture coordinates
private var _mirrorUv:Boolean = false;
// OBJ files do not contain vertex colors
// but many shaders will require this data
// if false, the buffer is filled with pure white
private var _randomVertexColors:Boolean = true;
// constants used in parsing OBJ data
private const LINE_FEED:String = String.fromCharCode(10);
private const SPACE:String = String.fromCharCode(32);
private const SLASH:String = "/";
private const VERTEX:String = "v";
private const NORMAL:String = "vn";
private const UV:String = "vt";
private const INDEX_DATA:String = "f";
// temporary vars used during parsing OBJ data
private var _scale:Number;
private var _faceIndex:uint;
private var _vertices:Vector.<Number>;
private var _normals:Vector.<Number>;
private var _uvs:Vector.<Number>;
private var _cachedRawNormalsBuffer:Vector.<Number>;
// the raw data that is used to create Stage3d buffers
protected var _rawIndexBuffer:Vector.<uint>;
protected var _rawPositionsBuffer:Vector.<Number>;
protected var _rawUvBuffer:Vector.<Number>;
protected var _rawNormalsBuffer:Vector.<Number>;
protected var _rawColorsBuffer:Vector.<Number>;


// the class constructor - where everything begins
public function Stage3dObjParser(definition:String, scale:Number = 1, dataIsZxy:Boolean = false, textureFlip:Boolean = true)
{
	_vertexDataIsZxy = dataIsZxy;
	_mirrorUv = textureFlip;

	_rawColorsBuffer = new Vector.<Number>();
	_rawIndexBuffer = new Vector.<uint>();
	_rawPositionsBuffer = new Vector.<Number>();
	_rawUvBuffer = new Vector.<Number>();
	_rawNormalsBuffer = new Vector.<Number>();
	_scale = scale;

	// Get data as string.

	//var definition:String = ObjBytes.readUTFBytes(ObjBytes.bytesAvailable);

	// Init raw data containers.
	_vertices = new Vector.<Number>();
	_normals = new Vector.<Number>();
	_uvs = new Vector.<Number>();

	// Split data in to lines and parse all lines.
	var lines:Array = definition.split(LINE_FEED);
	var loop:uint = lines.length;
	for(var i:uint = 0; i < loop; ++i)
		parseLine(lines[i]);
}

private function parseLine(line:String):void
{
	// Split line into words.
	var words:Array = line.split(SPACE);

	// Prepare the data of the line.
	if (words.length > 0)
		var data:Array = words.slice(1);
	else
		return;

	// Check first word and delegate remainder to proper parser.
	var firstWord:String = words[0];
	switch (firstWord)
	{
		case VERTEX:
			parseVertex(data);
			break;
		case NORMAL:
			parseNormal(data);
			break;
		case UV:
			parseUV(data);
			break;
		case INDEX_DATA:
			parseIndex(data);
			break;
	}
}

private function parseVertex(data:Array):void
{
	if ((data[0] == '') || (data[0] == ' ')) 
		data = data.slice(1); // delete blanks
	if (_vertexDataIsZxy)
	{
		//if (!_vertices.length) trace('zxy parseVertex: ' 
		// + data[1] + ',' + data[2] + ',' + data[0]);
		_vertices.push(Number(data[1])*_scale);
		_vertices.push(Number(data[2])*_scale);
		_vertices.push(Number(data[0])*_scale);
	}
	else // normal operation: x,y,z
	{
		//if (!_vertices.length) trace('parseVertex: ' + data);
		var loop:uint = data.length;
		if (loop > 3) loop = 3;
		for (var i:uint = 0; i < loop; ++i)
		{
			var element:String = data[i];
			_vertices.push(Number(element)*_scale);
		}
	}
}

private function parseNormal(data:Array):void
{
	if ((data[0] == '') || (data[0] == ' ')) 
		data = data.slice(1); // delete blanks
	//if (!_normals.length) trace('parseNormal:' + data);
	var loop:uint = data.length;
	if (loop > 3) loop = 3;
	for (var i:uint = 0; i < loop; ++i)
	{
		var element:String = data[i];
		if (element != null) // handle 3dsmax extra spaces
			_normals.push(Number(element));
	}
}

private function parseUV(data:Array):void
{
	if ((data[0] == '') || (data[0] == ' ')) 
		data = data.slice(1); // delete blanks
	//if (!_uvs.length) trace('parseUV:' + data);
	var loop:uint = data.length;
	if (loop > 2) loop = 2;
	for (var i:uint = 0; i < loop; ++i)
	{
		var element:String = data[i];
		_uvs.push(Number(element));
	}
}

private function parseIndex(data:Array):void
{
	//if (!_rawIndexBuffer.length) trace('parseIndex:' + data);
	var triplet:String;
	var subdata:Array;
	var vertexIndex:int;
	var uvIndex:int;
	var normalIndex:int;
	var index:uint;

	// Process elements.
	var i:uint;
	var loop:uint = data.length;
	var starthere:uint = 0;
	while ((data[starthere] == '') || (data[starthere] == ' ')) 
		starthere++; // ignore blanks

	loop = starthere + 3;

	// loop through each element and grab values stored earlier
	// elements come as vertexIndex/uvIndex/normalIndex
	for(i = starthere; i < loop; ++i)
	{
		triplet = data[i]; 
		subdata = triplet.split(SLASH);
		vertexIndex = int(subdata[0]) - 1;
		uvIndex     = int(subdata[1]) - 1;
		normalIndex = int(subdata[2]) - 1;

		// sanity check
		if(vertexIndex < 0) vertexIndex = 0;
		if(uvIndex < 0) uvIndex = 0;
		if(normalIndex < 0) normalIndex = 0;

		// Extract from parse raw data to mesh raw data.

		// Vertex (x,y,z)
		index = 3*vertexIndex;
		_rawPositionsBuffer.push(_vertices[index + 0], 
			_vertices[index + 1], _vertices[index + 2]);

		// Color (vertex r,g,b,a)
		if (_randomVertexColors)
			_rawColorsBuffer.push(Math.random(), 
				Math.random(), Math.random(), 1);
		else
			_rawColorsBuffer.push(1, 1, 1, 1); // pure white

		// Normals (nx,ny,nz) - *if* included in the file
		if (_normals.length)
		{
			index = 3*normalIndex;
			_rawNormalsBuffer.push(_normals[index + 0], 
				_normals[index + 1], _normals[index + 2]);
		}

		// Texture coordinates (u,v)
		index = 2*uvIndex;
		if (_mirrorUv)
			_rawUvBuffer.push(_uvs[index+0], 1-_uvs[index+1]);
		else
			_rawUvBuffer.push(1-_uvs[index+0],1-_uvs[index+1]);
	}

	// Create index buffer - one entry for each polygon
	_rawIndexBuffer.push(_faceIndex+0,_faceIndex+1,_faceIndex+2);
	_faceIndex += 3;
	
}

// These functions return Stage3d buffers
// (uploading them first if required)


public function GetVertexData(uv:Boolean, normal:Boolean, color:Boolean):Vector.<Number>
{
	var _meshVertexData:Vector.<Number> = new Vector.<Number>();
	var lastVertex:uint=0;
	var lastUV:uint=0;
	var lastNormal:uint=0;
	var lastColor:uint=0;
	
	if (normal && _rawNormalsBuffer.length == 0)
		forceNormals();
	
	if(_rawPositionsBuffer.length == 0)
		throw new Error("Raw Vertex buffer is empty");
		
	for( var i:uint=0; i< _rawPositionsBuffer.length/3; i++ ) 
	{
		_meshVertexData.push(_rawPositionsBuffer[lastVertex]);
		_meshVertexData.push(_rawPositionsBuffer[lastVertex+1]);
		_meshVertexData.push(_rawPositionsBuffer[lastVertex+2]);
		lastVertex += 3;
		
		if(uv && _rawUvBuffer.length >= 0)
		{
			_meshVertexData.push(_rawUvBuffer[lastUV]);
			_meshVertexData.push(_rawUvBuffer[lastUV+1]);
			lastUV += 2;
		}
		if(normal && _rawNormalsBuffer.length >= 0)
		{
			_meshVertexData.push(_rawNormalsBuffer[lastNormal]);
			_meshVertexData.push(_rawNormalsBuffer[lastNormal+1]);
			_meshVertexData.push(_rawNormalsBuffer[lastNormal+2]);
			lastNormal += 3;
		}
		if(color && _rawColorsBuffer.length > 0)
		{
			_meshVertexData.push(_rawColorsBuffer[lastColor]);
			_meshVertexData.push(_rawColorsBuffer[lastColor+1]);
			_meshVertexData.push(_rawColorsBuffer[lastColor+2]);
			_meshVertexData.push(_rawColorsBuffer[lastColor+3]);
			lastColor += 4;
		}
	}
	return _meshVertexData;
}

public function GetIndexData():Vector.<uint>
{
	if(_rawIndexBuffer.length == 0)
		throw new Error("Raw Index buffer is empty");
		
	return _rawIndexBuffer;
}
public function get indexBufferCount():int
{
	return _rawIndexBuffer.length / 3;
}


public function restoreNormals():void
{	// utility function
	_rawNormalsBuffer = _cachedRawNormalsBuffer.concat();
}

public function get3PointNormal(
	p0:Vector3D, p1:Vector3D, p2:Vector3D):Vector3D
{	// utility function
	// calculate the normal from three vectors
	var p0p1:Vector3D = p1.subtract(p0);
	var p0p2:Vector3D = p2.subtract(p0);
	var normal:Vector3D = p0p1.crossProduct(p0p2);
	normal.normalize();
	return normal;
}

public function forceNormals():void
{	// utility function
	// useful for when the OBJ file doesn't have normal data
	// we can calculate it manually by calling this function
	_cachedRawNormalsBuffer = _rawNormalsBuffer.concat();
	var i:uint, index:uint;
	// Translate vertices to vector3d array.
	var loop:uint = _rawPositionsBuffer.length/3;
	var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
	var vertex:Vector3D;
	for(i = 0; i < loop; ++i)
	{
		index = 3*i;
		vertex = new Vector3D(_rawPositionsBuffer[index],
			_rawPositionsBuffer[index + 1], 
			_rawPositionsBuffer[index + 2]);
		vertices.push(vertex);
	}
	// Calculate normals.
	loop = vertices.length;
	var p0:Vector3D, p1:Vector3D, p2:Vector3D, normal:Vector3D;
	_rawNormalsBuffer = new Vector.<Number>();
	for(i = 0; i < loop; i += 3)
	{
		p0 = vertices[i];
		p1 = vertices[i + 1];
		p2 = vertices[i + 2];
		normal = get3PointNormal(p0, p1, p2);
		_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
		_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
		_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
	}
}


// turns all mesh data into AS3 source code
public function toString():String
{
	var str:String;
	str = "// Stage3d Model Data begins\n\n";

	str += "private var _Index:Vector.<uint> ";
	str += "= new Vector.<uint>([";
	str += _rawIndexBuffer.toString();
	str += "]);\n\n";
	
	str += "private var _Positions:Vector.<Number> ";
	str += "= new Vector.<Number>([";
	str += _rawPositionsBuffer.toString();
	str += "]);\n\n";

	str += "private var _UVs:Vector.<Number> = ";
	str += "new Vector.<Number>([";
	str += _rawUvBuffer.toString();
	str += "]);\n\n";

	str += "private var _Normals:Vector.<Number> = ";
	str += "new Vector.<Number>([";
	str += _rawNormalsBuffer.toString();
	str += "]);\n\n";

	str += "private var _Colors:Vector.<Number> = ";
	str += "new Vector.<Number>([";
	str += _rawColorsBuffer.toString();
	str += "]);\n\n";
	
	str += "// Stage3d Model Data ends\n";
	return str;
}

} // end class

} // end package



