package blendhx.editor.commands;

import blendhx.editor.helpers.Color;

import flash.events.Event;
import flash.desktop.NativeApplication;
import flash.utils.ByteArray;
import flash.filesystem.*;
import flash.data.EncryptedLocalStore;

class ProjectOpenCommand extends Command
{
	private var newProjectDirectory:File;
	
	override public function execute():Void
	{
		newProjectDirectory = File.documentsDirectory;
		
		newProjectDirectory.addEventListener(Event.SELECT, onBrowseForNewProject);
		newProjectDirectory.addEventListener(Event.CANCEL, cancel     );
		newProjectDirectory.browseForDirectory("Select a blendHX project directory");
	}
	
	private function cancel(e:Event)
	{
		dispose();
	}
	
	public function onBrowseForNewProject(e:Event):Void
	{
		var casheDirectory:File = newProjectDirectory.resolvePath("cashe");
		var sourceDirectory:File = newProjectDirectory.resolvePath("source");
		
		if(casheDirectory.exists && sourceDirectory.exists)
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(newProjectDirectory.nativePath);
			bytes.position = 0;
			EncryptedLocalStore.setItem("projectDirectory", bytes);
			
			restartApplication();
		}
		else
		{
			trace("Selected directory is not a blendHX project");
		}
			
		dispose();
	}
	
	override public function dispose()
	{
		newProjectDirectory.removeEventListener(Event.SELECT, onBrowseForNewProject);
		newProjectDirectory.removeEventListener(Event.CANCEL, cancel     );
		newProjectDirectory = null;
	}

	private function restartApplication()
	{
		NativeApplication.nativeApplication.exit();
		var restartBat:File = File.applicationDirectory.resolvePath("apps/restart.bat");
		restartBat.openWithDefaultApplication();
	}
}