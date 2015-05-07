package blendhx.editor.events;

import blendhx.engine.components.IComponent;

class ComponentEvent extends DisposableEvent
{
	public static inline var NEW    :String = "component new";
	public static inline var REMOVE :String = "component remove";
	public static inline var ENABLE :String = "component enabality was changed";
	
	public var sourceURL:String;
	public var component:IComponent;
	
	override public function dispose():Void
	{
		component = null;
		sourceURL = null;
	}
}
