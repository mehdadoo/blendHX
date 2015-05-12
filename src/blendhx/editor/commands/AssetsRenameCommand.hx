package blendhx.editor.commands;

import blendhx.editor.events.ProjectEvent;
import blendhx.engine.components.IComponent;
import blendhx.engine.components.IComposite;

import blendhx.editor.helpers.Utils;
import blendhx.editor.ui.FileItem;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.AssetsEvent;
import blendhx.editor.events.ProgressEvent;

import blendhx.editor.commands.ProjectReloadScriptsCommand;
import blendhx.editor.helpers.Color;

import flash.filesystem.*;

class AssetsRenameCommand extends Command
{
	private var fileItemEvent:AssetsEvent;
	private var file:File;
	private var renamedFile:File;
	
	private var components:Array<IComponent>;
	
	
	override public function execute():Void
	{
		fileItemEvent = cast event;
		file = model.selectedFileItem.file;
		renamedFile = file.parent.resolvePath( fileItemEvent.fileName );
		
		if( validate() )
		{
			if( model.selectedFileItem.type == ObjectType.SCRIPT)
			{
				editScriptClassName();
				reloadScripts();
			}
			
			renameAsset();
		}
		
		//force Asset panel update
		model.selectedFileItem = null;
		super.execute();
	}
	
	private function reloadScripts():Void
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.RELOAD_SCRIPTS);
		model.dispatchEvent( e );
		e.dispose();
	}
	
	private function editScriptClassName()
	{
		var fs:FileStream = new FileStream();
		fs.open( file, FileMode.READ );
		var scriptString:String = fs.readUTFBytes( fs.bytesAvailable );
		var oldClassName:String = "class " + file.name.split( ".")[0]; 
		var newClassName:String = "class " + renamedFile.name.split( ".")[0]; 
		scriptString = StringTools.replace( scriptString, oldClassName, newClassName);
		fs.close();
		
		fs.open( file, FileMode.WRITE);
		fs.writeUTFBytes( scriptString );
		fs.close();
	}
	private function validate():Bool
	{
		//Name has not changed
		if( file.name == fileItemEvent.fileName)
		{ 
			return false;
		}
		//Folder rename not implemented yet
		else if( file.isDirectory && file.getDirectoryListing().length > 0 )
		{
			trace( "Directory not empty. Feature not implemented in " + model.version, Color.ORANGE);
			return false;
		}
		//A file already exists with the new name
		else if (renamedFile.exists)
		{
			trace("A file with the new name already exists", Color.ORANGE);
			return false;
		}
		return true;
	}
	
	private function renameAsset():Void
	{
		file.moveTo(renamedFile);
			
		var sourceURL:String = model.selectedFileItem.sourceURL;
		var destinationURL:String = Utils.getLocalURL( model.sourceDirectory, renamedFile );
		
		model.assets.moveAsset( sourceURL, destinationURL);
	}
	
	override public function dispose():Void
	{
		fileItemEvent = null;
		file = null;
		renamedFile = null;
	
		super.dispose();
	}
}