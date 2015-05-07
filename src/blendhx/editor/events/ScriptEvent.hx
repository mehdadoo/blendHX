package blendhx.editor.events;

import blendhx.engine.components.IComponent;

class ScriptEvent extends DisposableEvent
{
	public static inline var CHANGE :String = "Script properties changed";
	
	public var component:IComponent;
	public var values:Array<Dynamic>;
	public var componentProperties:Array<String>;
	
	override public function dispose():Void
	{
		component = null;
		values = null;
		componentProperties = null;
	}
}
