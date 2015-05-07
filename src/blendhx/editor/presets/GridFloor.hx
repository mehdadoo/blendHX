package blendhx.editor.presets;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Material;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.components.Entity;
import blendhx.engine.presets.GridFloorMesh;

import blendhx.editor.presets.WireFrameShader;


import flash.geom.Vector3D;
import flash.system.ApplicationDomain;

/**
* @author 
 */
class GridFloor extends Entity
{
	var meshRenderer:MeshRenderer;
	public var mesh:GridFloorMesh;
	var material:Material;
	var shader:WireFrameShader;
	
	public function new( assets:Assets) 
	{
		super( "Grid Floor" );
		
		mesh = assets.get( Assets.MESH, 1);
		
		material = new Material();
		material.shaderURL = "blendhx/editor/presets/WireFrameShader.hx";
		material.sourceURL = "GridFloorMaterial";
		material.id = 0;
		//assets.materials.push( material ); 
		
		shader = new WireFrameShader();
		shader.create( ApplicationDomain.currentDomain );
		shader.lineColor = new Vector3D(.28, .28, .28, 1);
		shader.lineWidth = new Vector3D(1 - 0.015, 0);
		material.shader = shader;
		
		meshRenderer = new MeshRenderer();
		meshRenderer.material    = material;
		meshRenderer.mesh    = mesh;
		
		addChild(  meshRenderer );
	}
	
	override public function dispose()
	{
		super.dispose();
		material.dispose();
		mesh = null;
		material = null;
		meshRenderer = null;
		shader = null;
	}
}