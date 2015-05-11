package blendhx.engine.presets;

import flash.geom.Matrix3D;
import hxsl.Shader;

class DefaultShader extends Shader
{
	override public function initProperties()
	{
		editorProperties = [];
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
	}
	
	override public function updateMatrix(modelMatrix:Matrix3D, cameraMatrix:Matrix3D)
	{
		transformationMatrix = modelMatrix;
		projectionMatrix = cameraMatrix;
	}
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
			normal : Float3
		};
		var lpow : Float;
		
		function vertex(transformationMatrix : M44, projectionMatrix : M44, lamp:Float3) 
		{
			out = input.pos.xyzw * transformationMatrix * projectionMatrix;
			var tnorm = (input.normal * transformationMatrix).normalize();
			lpow = lamp.dot(tnorm).max(0);
		}
		function fragment( color:Color) {
			out = color * (lpow * 0.8 + 0.2);
		}
		
	};

}