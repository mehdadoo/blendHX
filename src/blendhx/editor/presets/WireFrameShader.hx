package blendhx.editor.presets;

import flash.geom.Matrix3D;
import hxsl.Shader;

class WireFrameShader extends Shader
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
	
	static var SRC = 
	{
		var input : 
		{
			pos : Float3,
			vertexColor : Float4
		};
		var vertexColorVarying:Float4;
		var depth:Float;
		function vertex(transformationMatrix : M44, projectionMatrix : M44) 
		{
			var final:Float4 = input.pos.xyzw * transformationMatrix * projectionMatrix;
			//final.z += 0.01;
			out = final;
			depth = final.z;
			vertexColorVarying = input.vertexColor;
		}
		
		function fragment(lineColor:Float4, lineWidth:Float2) 
		{
			var temp:Float4;
			temp.x = vertexColorVarying.x + vertexColorVarying.y;
			temp.y = vertexColorVarying.y + vertexColorVarying.z;
			temp.z = vertexColorVarying.z + vertexColorVarying.w;
			temp.w = vertexColorVarying.w + vertexColorVarying.x;
			
			temp = temp - lineWidth.xxxx + ((depth - 10)/1000);
			temp = temp.lt( lineWidth.yyyy );
			
			temp.x = temp.x * temp.y;
			temp.x = temp.x * temp.z;
			temp.x = temp.x * temp.w;
			
			temp.x = lineWidth.x - temp.x;
			kill(temp.x);
			out = lineColor;
		}
	};

}