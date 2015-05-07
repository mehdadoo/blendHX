package blendhx.editor.events;

import blendhx.editor.ui.controls.ControlBase;

class ControlBaseEvent extends DisposableEvent
{
	public static inline var FOCUS:String = "focus";
	
	public var control:ControlBase;
	
	override public function dispose():Void
	{
		control = null;
	}
}