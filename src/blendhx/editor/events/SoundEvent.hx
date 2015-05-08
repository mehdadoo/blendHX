package blendhx.editor.events;

import blendhx.engine.components.Sound;

class SoundEvent extends DisposableEvent
{
	public static inline var CHANGE:String = "sound change";
	
	public var sound:Sound;
	
	public var sound_id:UInt = 0;
	public var material_id:UInt = 0;
	public var playOnAwake:Bool;
	public var loop:Bool;
	public var is2D:Bool;
	public var volume:Float;
	
	override public function dispose():Void
	{
		sound = null;
	}
}
