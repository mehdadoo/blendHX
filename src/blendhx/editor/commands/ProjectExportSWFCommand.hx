package blendhx.editor.commands;

import blendhx.editor.helpers.Color;

import flash.events.Event;
import flash.desktop.NativeApplication;
import flash.utils.ByteArray;
import flash.filesystem.*;
import flash.data.EncryptedLocalStore;
import flash.errors.Error;

class ProjectExportSWFCommand extends Command
{
	override public function execute():Void
	{
		var casheDirectory :File = model.casheDirectory;
		var exportDirectory:File = model.projectDirectory.resolvePath( "export" );
		var swfPlayerFile  :File = File.applicationDirectory.resolvePath( "templates/player.swf");
		
		if(exportDirectory.exists)
		{
			try
			{
				exportDirectory.deleteDirectory(true);
			}
			catch(e:Error)
			{
				trace("Error exporting to swf. Probably the file is in use.", Color.ORANGE);
				dispose();
				return;
			}
				
		}
			
		

		exportDirectory.createDirectory();
		
		casheDirectory.copyTo(exportDirectory.resolvePath("cashe"), true);
		swfPlayerFile.copyTo (exportDirectory.resolvePath("player.swf"), true);
		
		exportDirectory.openWithDefaultApplication();
		
		dispose();
	}
}