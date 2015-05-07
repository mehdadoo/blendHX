package shaders;
import flash.geom.Vector3D;
import flash.display3D.textures.Texture;

import blendhx.core.assets.*;
import flash.geom.Matrix3D;
import hxsl.Shader;

/**
* @author 
 */

class UnlitShader extends Shader
{
	override public function initProperties()
	{
		editorProperties = [ "color", "Color", "Diffuse", "Texture"];
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
		diffuseTexture = values[1];
		color = values[0];
	}
	
	override public function updateMatrix(modelMatrix:Matrix3D, cameraMatrix:Matrix3D)
	{
		transformationMatrix = modelMatrix;
		projectionMatrix = cameraMatrix;
	}
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2
		};
		var vuv:Float2;
		
		function vertex(transformationMatrix : M44, projectionMatrix : M44) 
		{
			out = input.pos.xyzw * transformationMatrix * projectionMatrix;
			vuv = input.uv.xy;
		}
		
		function fragment(color:Color, diffuseTexture : Texture) 
		{
			out =  diffuseTexture.get(vuv, wrap, dxt1) * color;
		}
		
	};

}