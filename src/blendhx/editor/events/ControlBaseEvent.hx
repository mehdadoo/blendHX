package blendhx.editor.events;

import blendhx.editor.ui.controls.ControlBase;

class ControlBaseEvent extends DisposableEvent
{
	public static inline var FOCUS:String = "focus";
	public static inline var UN_FOCUS:String = "unfocus";
	
	public var control:ControlBase;
	
	override public function dispose():Void
	{
		control = null;
	}
}