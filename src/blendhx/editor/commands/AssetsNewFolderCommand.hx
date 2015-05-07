package blendhx.editor.commands;

import flash.filesystem.File;

class AssetsNewFolderCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		var newFolder:File =  currentDirectory.resolvePath("New Folder");
		var i:UInt = 1;
		while( newFolder.exists )
		{
			newFolder = currentDirectory.resolvePath("New Folder "+i);
			i++;
		}
		newFolder.createDirectory();
		
		model.selectedFileItem = null;
		
		super.execute();
	}
}