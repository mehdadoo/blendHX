package blendhx.editor.commands;

import blendhx.editor.events.ControlBaseEvent;

class ControlBaseUnfocusCommand extends Command
{
	override public function execute():Void
	{
		model.focusedControlBase = null;
		
		super.execute();
	}
}