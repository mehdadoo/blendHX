package blendhx.editor.commands;

import flash.utils.ByteArray;
import flash.filesystem.*;
import flash.data.EncryptedLocalStore;

class ProjectLoadCommand extends Command
{
	override public function execute():Void
	{
		var bytes:ByteArray = null;
		var projectDirectory:File;
		
		try
		{
			bytes = EncryptedLocalStore.getItem("projectDirectory");
		}
		catch(e:Dynamic)
		{
			EncryptedLocalStore.reset();
		}
		
		if(bytes!=null)
		{
			projectDirectory = new File().resolvePath( bytes.readObject() );
			bytes.clear();
			
			if(!projectDirectory.exists)
				createNewProject();
			else
				model.projectDirectory = projectDirectory;
		}
		else
		{
			createNewProject();
		}
		
		super.execute();
	}
	
	private function createNewProject()
	{
		var newProjectDirectory:File;
		var bytes:ByteArray;
		
		newProjectDirectory = File.documentsDirectory.resolvePath("blendHX Project");
		newProjectDirectory.createDirectory();
		
		bytes = new ByteArray();
		bytes.writeObject(newProjectDirectory.nativePath);
		
		EncryptedLocalStore.setItem("projectDirectory", bytes);

		var newProjectTemplate:File = File.applicationDirectory.resolvePath("templates/blendHX Project");
		
		newProjectTemplate.copyTo (newProjectDirectory, true);
		
		model.projectDirectory = newProjectDirectory;
		
		bytes.clear();
	}
}