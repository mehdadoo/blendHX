package blendhx.editor.presets;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Mesh;
import blendhx.engine.assets.Material;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.components.Entity;


import blendhx.editor.presets.WireFrameShader;
import blendhx.editor.presets.GizmoShader;

import flash.geom.Vector3D;
import flash.system.ApplicationDomain;


class TransformGizmo extends Entity
{
	var redMaterial:Material;
	var greenMaterial:Material;
	var blueMaterial:Material;
	
	public function new( assets:Assets) 
	{
		super( "Transform Gizmo" );
		
		var id:UInt = assets.getID( "editor/TransformGizmo.obj" );
		var mesh:Mesh = assets.get( Assets.MESH, id);
		
		redMaterial   = new Material();
		greenMaterial = new Material();
		blueMaterial  = new Material();
		
		var redShader:GizmoShader   = new GizmoShader();
		var greenShader:GizmoShader = new GizmoShader();
		var blueShader:GizmoShader  = new GizmoShader();
		
		redShader.create( ApplicationDomain.currentDomain );
		greenShader.create( ApplicationDomain.currentDomain );
		blueShader.create( ApplicationDomain.currentDomain );
		
		redShader.color   = 0xff0000;
		greenShader.color = 0x00ff00;
		blueShader.color  = 0x0000ff;
		
		redMaterial.shader   = redShader;
		greenMaterial.shader = greenShader;
		blueMaterial.shader  = blueShader;
		
		
		var red:Entity   = new Entity("red");
		var green:Entity = new Entity("green");
		var blue:Entity  = new Entity("blue");
		
		var redMeshRenderer:MeshRenderer = new MeshRenderer();
		redMeshRenderer.material = redMaterial;
		redMeshRenderer.mesh     = mesh;
		
		var greenMeshRenderer:MeshRenderer = new MeshRenderer();
		greenMeshRenderer.material = greenMaterial;
		greenMeshRenderer.mesh     = mesh;
		
		var blueMeshRenderer:MeshRenderer = new MeshRenderer();
		blueMeshRenderer.material = blueMaterial;
		blueMeshRenderer.mesh     = mesh;
		
		red.addChild(   redMeshRenderer );
		green.addChild( greenMeshRenderer );
		blue.addChild(  blueMeshRenderer );
		
		green.transform.rotationY = 90;
		blue.transform.rotationZ  = 90;
		red.transform.rotationY   = 0;
		
		
		addChild( red );
		addChild( green );
		addChild( blue );
	}
	
	override public function dispose()
	{
		super.dispose();
		if(redMaterial!=null)
		{
			redMaterial.dispose();
			greenMaterial.dispose();
			blueMaterial.dispose();
		}
		
		redMaterial = null;
		greenMaterial = null;
		blueMaterial = null;
	}
}