package blendhx.editor.commands;
import blendhx.editor.helpers.Utils;

import blendhx.editor.helpers.Color;
import blendhx.editor.ui.FileItem;
import blendhx.editor.events.AssetsEvent;

import flash.filesystem.File;
import flash.errors.Error;

class AssetsDeleteCommand extends Command
{
	override public function execute():Void
	{
		var fileItemEvent:AssetsEvent = cast event;
		var file:File = fileItemEvent.fileItem.file;
			
		if(file.isDirectory)
		{
			try
			{
				file.deleteDirectory(false);
			}
			catch(e:Error)
			{
				trace(e.message + " Feature not implemented in " + model.version, Color.ORANGE);
			}
		}
		else
		{
			file.moveToTrash();
			model.assets.removeAsset( Utils.getLocalURL(model.sourceDirectory, file) );
		}
		
		model.selectedFileItem = null;
			
		super.execute();
	}
}