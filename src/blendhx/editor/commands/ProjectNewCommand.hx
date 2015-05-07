package blendhx.editor.commands;

import blendhx.editor.helpers.Color;

import flash.events.Event;
import flash.desktop.NativeApplication;
import flash.utils.ByteArray;
import flash.filesystem.*;
import flash.data.EncryptedLocalStore;

class ProjectNewCommand extends Command
{
	private var newProjectDirectory:File;
	
	override public function execute():Void
	{
		newProjectDirectory = File.documentsDirectory;
		
		newProjectDirectory.addEventListener(Event.SELECT, onBrowseForNewProject);
		newProjectDirectory.addEventListener(Event.CANCEL, cancel     );
		newProjectDirectory.browseForDirectory("Select an empty directory for a new blendHX project");
	}
	
	private function cancel(e:Event)
	{
		dispose();
	}
	
	public function onBrowseForNewProject(e:Event):Void
	{
		if(newProjectDirectory.getDirectoryListing().length > 0)
			trace("Directory is not empty", Color.ORANGE);
		else
			createNewProject();
			
		dispose();
	}
	
	private function createNewProject()
	{
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(newProjectDirectory.nativePath);
		
		EncryptedLocalStore.setItem("projectDirectory", bytes);
		bytes.clear();
		
		var newProjectTemplate:File = File.applicationDirectory.resolvePath("templates/blendHX Project");
		newProjectTemplate.copyTo (newProjectDirectory, true);
	
		dispose();
		restartApplication();
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