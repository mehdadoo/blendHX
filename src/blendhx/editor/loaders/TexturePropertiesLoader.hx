package blendhx.editor.loaders;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ErrorEvent;
import flash.filesystem.*;
import flash.display.Loader;
import flash.utils.ByteArray;


class TexturePropertiesLoader extends EventDispatcher
{
	private var loader:Loader;
	
	public var width:Int;
	public var height:Int;
	public var bytes:ByteArray;
	
	private var file:File;
	
	public function new( file:File ) 
	{
		super();
		
		this.file = file;
	}	
	
	public function load():Void
	{
		loader = new Loader();
		var stream:FileStream = new FileStream();
		bytes = new ByteArray();
		
		stream.open(file, FileMode.READ);
		stream.readBytes(bytes, 0, stream.bytesAvailable);
		stream.close();
		
		loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
		loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError   );
		
		loader.loadBytes( bytes );
	}
	
	private function onLoaderComplete( e:Event )
	{
		width  = Std.int( loader.width );
		height = Std.int( loader.height);

		if( isPowerOfTwo(width) && isPowerOfTwo(height))
			dispatchEvent( new Event( Event.COMPLETE ) );
		else
		{
			var e:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR );
			e.text = "Only power of two texture sizes are supported.";
			dispatchEvent( e );
		}
	
		dispose();
	}
	private function onError( e:IOErrorEvent )
	{
		
		var e:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR );
		e.text = "Can't open corrupt";
		dispatchEvent( e );
		
		dispose();
	}
	private inline function isPowerOfTwo(n:Int):Bool
	{
		return (n & (n - 1)) == 0;
	}
	
	private function dispose():Void
	{
		loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
		loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onError   );
		
		loader.unload();
		loader = null;
		
		file = null;
		bytes.clear();
		bytes = null;
	}
	
}