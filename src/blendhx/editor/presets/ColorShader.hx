package blendhx.editor.presets;

import flash.geom.Matrix3D;

class ColorShader extends hxsl.Shader
{
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