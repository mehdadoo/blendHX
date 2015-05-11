package blendhx.editor.commands;

import blendhx.editor.ui.FileItem;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.AssetsEvent;

class AssetsSelectCommand extends Command
{
	override public function execute():Void
	{
		var fileItemEvent:AssetsEvent = cast event;
		var fileItem:FileItem = fileItemEvent.fileItem;
		
		if(model.focusedControlBase != null)
			model.focusedControlBase.unfocus();
		
		model.selectedFileItem = fileItemEvent.fileItem;
		
		super.execute();
	}
}