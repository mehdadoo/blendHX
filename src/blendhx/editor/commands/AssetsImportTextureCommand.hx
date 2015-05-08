package blendhx.editor.commands;

import blendhx.engine.assets.Texture;

import blendhx.editor.Process;
import blendhx.editor.loaders.TexturePropertiesLoader;
import blendhx.editor.loaders.BytesLoader;
import blendhx.editor.helpers.Utils;
import blendhx.editor.helpers.Color;
import blendhx.editor.events.ProgressEvent;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.filesystem.*;
import flash.net.FileFilter;

import flash.Vector;

class AssetsImportTextureCommand extends Command
{
	private var texture:Texture;
	private var bytesLoader:BytesLoader;
	private var texturePropertiesLoader:TexturePropertiesLoader;
	private var encodeProcess:Process;
	private var file:File;
	private var sourceFolderFile:File;
	
	override public function execute():Void
	{
 		var meshesFilter = new FileFilter("PNG", "*.png");
		
		file = new File();
		file.addEventListener(Event.SELECT, importFile );
		file.addEventListener(Event.CANCEL, cancel     );
		file.browseForOpen("Import Power of 2 Texture", [ meshesFilter]);	
	}
	
	private function cancel(e:Event)
	{
		dispose();
	}
	
	private function importFile(e:Event)
	{
		sourceFolderFile = model.currentAssetsDirectory.resolvePath( file.name );
		
		if( sourceFolderFile.exists )
		{
			trace("A file with the same name already exists.", Color.RED);
			dispose();
			return;
		}
			
		texturePropertiesLoader = new TexturePropertiesLoader(file);
		texturePropertiesLoader.addEventListener( Event.COMPLETE  , onTexturePropertiesLoaded);
		texturePropertiesLoader.addEventListener( ErrorEvent.ERROR, onError);
		texturePropertiesLoader.load();

		
		var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, 0, 1);
		e.isEndless = true;
		e.text = "Encoding ATF";
		model.dispatchEvent( e );
	}
	
	private function onError( e:ErrorEvent )
	{
		trace(e.text, Color.RED);
		dispose();
	}

	private function onTexturePropertiesLoaded( e:Event )
	{
		var sourceURL:String = Utils.getLocalURL(model.sourceDirectory, sourceFolderFile );
		var id:UInt = model.assets.getNewID();
		var fileName:String = "texture" + id + ".atf";

		var atfTool = File.applicationDirectory.resolvePath("apps/png2atf.exe");
		var args:Vector<String> = new Vector<String>();
		
		args.push("-c");
		args.push( "d");
		args.push("-r");
		args.push("-i");
		args.push( file.nativePath );
		args.push("-o");
		args.push( model.casheDirectory.resolvePath(fileName).nativePath );
		
		encodeProcess = Process.getInstance();
		encodeProcess.addEventListener( Event.COMPLETE  , onProcessComplete );
		encodeProcess.addEventListener( ErrorEvent.ERROR, onError    );
		encodeProcess.startProcess(args, atfTool);
		
		//although we don't need them now, but we won't have access to some variables elsewhere, so here they are initialized
		bytesLoader = new BytesLoader( fileName, model.casheDirectory.url );
		texture = new Texture( texturePropertiesLoader.width, texturePropertiesLoader.height );
		texture.sourceURL = sourceURL;
		texture.id = id;
	}
	
	private function onProcessComplete( e:Event ):Void
	{
		bytesLoader.addEventListener(blendhx.engine.events.Event.ERROR,    onBytesLoaderError);
		bytesLoader.addEventListener(blendhx.engine.events.Event.COMPLETE, onBytesLoaderLoad);
		bytesLoader.load();	
	}
	
	private function onBytesLoaderError( _ ):Void
	{
		trace("onBytesLoaderError", Color.RED);
		dispose();
	}
	private function onBytesLoaderLoad( _ ):Void
	{
		texture.bytes = bytesLoader.data;
		texture.initialize( model.assets );
		model.assets.textures.push( texture );
		
		file.copyTo( sourceFolderFile );
		model.selectedFileItem = null;
		
		//delete atf file. The file can't be deleted right now, because its not closed yet.
		var atfFile:File = model.casheDirectory.resolvePath( bytesLoader.file );
		var deleteTimer:haxe.Timer = new haxe.Timer( 1000 );
		deleteTimer.run = function()
		{
			var error = false;
			try{
				atfFile.deleteFile();
			}catch(e:flash.errors.IOError)
			{
				error = true;
				trace( "retrying delete atf cashe file");
			}
			if(error == false)
				deleteTimer.stop();
		}
		//end delete file
		
		dispose();
	}
	
	
	
	
	override public function dispose():Void
	{
		var pe:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		pe.text = "Load Complete";
		model.dispatchEvent( pe );
		
		file.removeEventListener(Event.SELECT, importFile );
		file.removeEventListener(Event.CANCEL, cancel     );
		file = null;
		
		if( texture != null )
		{
			texture = null;
		}
		
		if ( bytesLoader!=null )
		{
			bytesLoader.dispose();
			bytesLoader = null;
		}
		
		if (texturePropertiesLoader!=null)
		{
			texturePropertiesLoader.removeEventListener( Event.COMPLETE  , onTexturePropertiesLoaded);
			texturePropertiesLoader.removeEventListener( ErrorEvent.ERROR, onError);
			texturePropertiesLoader = null;
		}
			
		if (encodeProcess!=null)
		{
			encodeProcess.removeEventListener( Event.COMPLETE  , onProcessComplete );
			encodeProcess.removeEventListener( ErrorEvent.ERROR, onError    );
			encodeProcess = null;
		}
		
		super.dispose();
	}
}