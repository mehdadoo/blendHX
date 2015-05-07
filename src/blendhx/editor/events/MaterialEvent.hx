package blendhx.editor.events;

import blendhx.engine.assets.Material;

class MaterialEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "material change";
	
	public var material:Material;
	
	public var shaderURL:String = "";
	public var properties:Map<String, Dynamic>;
	
	override public function dispose():Void
	{
		material = null;
		properties = null;
	}
}