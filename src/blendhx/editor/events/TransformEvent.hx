package blendhx.editor.events;

import blendhx.engine.components.Transform;

class TransformEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "transform change";
	
	public var transform:Transform;
	
	public var x:Float          = 0;
	public var y:Float          = 0;
	public var z:Float          = 0;
	public var rotationX:Float  = 0;
	public var rotationY:Float  = 0;
	public var rotationZ:Float  = 0;
	public var scaleX:Float     = 0;
	public var scaleY:Float     = 0;
	public var scaleZ:Float     = 0;
	
	override public function dispose():Void
	{
		transform = null;
	}
}
