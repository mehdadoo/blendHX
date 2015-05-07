package blendhx.editor.events;

import blendhx.engine.components.MeshRenderer;

class MeshRendererEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "meshrenderer change";
	
	public var meshRenderer:MeshRenderer;
	
	public var mesh_id    :UInt = 0;
	public var material_id:UInt = 0;
	
	override public function dispose():Void
	{
		meshRenderer = null;
	}
}
