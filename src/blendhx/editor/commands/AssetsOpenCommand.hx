package blendhx.editor.commands;

import blendhx.editor.ui.FileItem;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.AssetsEvent;

import flash.errors.Error;

class AssetsOpenCommand extends Command
{
	override public function execute():Void
	{	
		var fileItemEvent:AssetsEvent = cast event;
		var fileItem:FileItem = fileItemEvent.fileItem;
		
		if(model.focusedControlBase != null)
			model.focusedControlBase.unfocus();
			
		if ( fileItem.type == ObjectType.FOLDER )
		{
			model.currentAssetsDirectory = model.currentAssetsDirectory.resolvePath(fileItem.file.name);
		}
		else if ( fileItem.type == ObjectType.BACK )
		{
			model.currentAssetsDirectory = model.currentAssetsDirectory.parent;
		}
		else
		{
			try
			{
				fileItem.file.openWithDefaultApplication();
			}
			catch(e:Error)
			{
				
				trace(e);
			}	
		}	
		
		super.execute();
	}
}