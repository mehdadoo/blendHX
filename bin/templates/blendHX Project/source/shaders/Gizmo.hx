package shaders;

import flash.geom.Matrix3D;

class Gizmo extends hxsl.Shader
{
	override public function initProperties()
	{
		editorProperties = [ "color", "Color", "scale", "Float"];
		
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
		color = values[0];
		scale = values[1];
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

		function vertex(transformationMatrix : M44, projectionMatrix : M44, scale:Float) 
		{
			var pos = input.pos.xyzw;
			
			var f4:Float4 = [0,0,0,1];
			var ddd = f4 * transformationMatrix * projectionMatrix;
			var w:Float = ddd.w;
			w *= scale;
			pos.xyz *= w;
			pos.w = 1;
			var end = pos.xyzw * transformationMatrix * projectionMatrix;
			end.z = 0.0;
			out = end;
		}
		
		function fragment(color:Color) 
		{
			out =  color;
		}
		
	};

}