package blendhx.editor.commands;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Material;
import blendhx.engine.components.MeshRenderer;

import blendhx.editor.events.MeshRendererEvent;

class MeshRendererChangeCommand extends Command
{
	override public function execute():Void
	{
		var meshRendererEvent:MeshRendererEvent = cast event;
		var meshRenderer:MeshRenderer = meshRendererEvent.meshRenderer;
		
		var material:Material = model.assets.get( Assets.MATERIAL, meshRendererEvent.material_id );
		if(material != null)
			meshRenderer.material = material;
		meshRenderer.mesh = model.assets.get( Assets.MESH, meshRendererEvent.mesh_id );
		
		super.execute();
	}
}