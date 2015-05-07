package blendhx.editor.events;

import blendhx.engine.components.Camera;

class CameraEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "camera change";
	
	public var camera:Camera;
	
	public var fov:Float = 60;
	public var near:Float = 0.1;
	public var far:Float = 1000;
	
	override public function dispose():Void
	{
		camera = null;
	}
}
