package blendhx.editor.ui.panels;

import blendhx.engine.components.MeshRenderer;

import blendhx.editor.events.MeshRendererEvent;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.Button;
import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.ObjectInput;
import blendhx.editor.helpers.ObjectType;


import hxsl.Shader;


class MeshRendererPanel extends Panel
{
	var mesh_input    :ObjectInput;
	var material_input:ObjectInput;
	
	public function new()
	{
		super("MeshRenderer", 200, true, true);
	}
	
	override private function initialize()
	{
		new Label( "Mesh File" , 30, null, this, 1, 1);
		mesh_input = new ObjectInput( "Mesh"    ,50, null, this, 1, 1, ControlBase.ROUND_BOTH,  ObjectType.MESH );
		
		new Label("Material File", 70, null, this, 1, 1);
		material_input = new ObjectInput( "Material"    ,90, null, this, 1, 1, ControlBase.ROUND_BOTH,  ObjectType.MATERIAL );
		
		new Button( "Reload Renderer", 120, updateModel, this);
	}
	
	override public function update()
	{
		var meshRenderer:MeshRenderer = cast component;
			
		mesh_input.value     = (meshRenderer.mesh     == null) ? "" : meshRenderer.mesh.sourceURL;
		material_input.value = (meshRenderer.material == null) ? "" : meshRenderer.material.sourceURL;
	}
	
	override private function updateModel() 
	{
		var e:MeshRendererEvent = new MeshRendererEvent( MeshRendererEvent.CHANGE );
		e.meshRenderer= cast component;
		e.mesh_id     = model.assets.getID( mesh_input.value );
		e.material_id = model.assets.getID( material_input.value );
		
		dispatchEvent( e );
	}
	
}