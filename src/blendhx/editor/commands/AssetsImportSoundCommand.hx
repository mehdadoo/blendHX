package blendhx.editor.commands;

import blendhx.engine.assets.Sound;

import blendhx.editor.helpers.Utils;
import blendhx.editor.helpers.Color;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.filesystem.*;
import flash.net.FileFilter;

class AssetsImportSoundCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		
 		var meshesFilter = new FileFilter("MP3", "*.mp3");
		
		var file:File = new File();
		file.addEventListener(Event.SELECT, importFile );
		file.addEventListener(Event.CANCEL, cancel     );
		file.browseForOpen("Import Sound", [ meshesFilter]);	
	}
	
	private function cancel(e:Event)
	{
		dispose();
	}
	private function importFile(e:Event)
	{
		var file:File = e.target;
		
		var sourceFolderFile:File =  model.currentAssetsDirectory.resolvePath( file.name );
		
		if(sourceFolderFile.exists)
		{
			trace("A file with the same name already exists.", Color.RED);
			dispose();
			return;
		}
		
		file.copyTo( sourceFolderFile );
		
		var bytes:ByteArray = new ByteArray();
		
		var stream = new FileStream();
		stream.open(file, FileMode.READ);
		stream.readBytes( bytes);
		stream.close();

		var sound:Sound = new Sound();
		
		//create the loader used by the assets library
		var sourceURL:String = Utils.getLocalURL(model.sourceDirectory, sourceFolderFile );
		var id:UInt = model.assets.getNewID();
		sound.bytes = bytes;
		sound.sourceURL = sourceURL;
		sound.id = id;
		model.assets.sounds.push( sound );
		sound.initialize( model.assets );
		
		model.selectedFileItem = null;
		
		dispose();
	}
}