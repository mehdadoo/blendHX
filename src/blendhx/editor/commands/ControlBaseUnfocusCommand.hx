package blendhx.editor.commands;

import blendhx.editor.events.ControlBaseEvent;

class ControlBaseUnfocusCommand extends Command
{
	override public function execute():Void
	{
		var controlBaseEvent:ControlBaseEvent = cast event;
		
		if(model.focusedControlBase != null && model.focusedControlBase != controlBaseEvent.control)
			model.focusedControlBase.unfocus();
			
		model.focusedControlBase = controlBaseEvent.control;
		
		super.execute();
	}
}