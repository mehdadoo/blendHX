package shaders;

import flash.geom.Matrix3D;

class UnlitLightmaped extends hxsl.Shader
{
	override public function initProperties()
	{
		editorProperties = [ "Diffuse", "Texture", "Lightmap", "Texture"];
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
		diffuseTexture = values[0];
		lightmapTexture = values[1];
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
		
		function fragment(diffuseTexture : Texture, lightmapTexture : Texture) 
		{
			var diffuse = diffuseTexture.get(vuv, wrap, dxt1);
			var lightmap = lightmapTexture.get(vuv, wrap, dxt1);
			out =  diffuse.mul(lightmap);
		}
		
	};

}