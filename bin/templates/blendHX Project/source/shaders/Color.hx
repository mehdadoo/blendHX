package shaders;

import flash.geom.Matrix3D;

class Color extends hxsl.Shader
{
	override public function initProperties()
	{
		editorProperties = [ "color", "Color"];
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
		color = values[0];
	}
	
	override public function updateMatrix(modelMatrix:Matrix3D, cameraMatrix:Matrix3D)
	{
		transformationMatrix = modelMatrix;
		projectionMatrix = cameraMatrix;
	}
	
	static var SRC = {
		var input : {
			pos : Float3
		};

		function vertex(transformationMatrix : M44, projectionMatrix : M44) 
		{
			out = input.pos.xyzw * transformationMatrix * projectionMatrix;
		}
		
		function fragment(color:Color) 
		{
			out =  color;
		}
		
	};

}