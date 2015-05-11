package blendhx.editor.events;

import blendhx.engine.components.Lamp;

class LampEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "lamp change";
	
	public var lamp:Lamp;
	
	public var energy:Float;
	public var shadow:Bool;
	
	override public function dispose():Void
	{
		lamp = null;
	}
}
