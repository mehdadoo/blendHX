package shaders;

import flash.geom.Matrix3D;

class Gizmo extends hxsl.Shader
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
			var end = input.pos.xyzw * transformationMatrix * projectionMatrix;
			end.z = 0.0;
			out = end;
		}
		
		function fragment(color:Color) 
		{
			out =  color;
		}
		
	};

}