package blendhx.engine.loaders;

import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;
//import flash.events.Event;
import flash.events.IOErrorEvent;

class Loader extends EventDispatcher implements ILoader
{
	public  var data:Dynamic;
	public  var file:String;
	public var folder:String;
	private var urlLoader:URLLoader;
	private var bytes:ByteArray;
	
	public function new(file:String,  folder:String) 
	{
		super();
		this.folder = folder;
		this.file = file;
	}
	
	override public function dispose()
	{
		data = null;
		urlLoader = null;
		bytes = null;
		super.dispose();
	}
	
	// load raw data
	public function load()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(flash.events.Event.COMPLETE, urlLoaderComplete );
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		var urlRequest:URLRequest = new URLRequest( folder + "/" + file );
		
		urlLoader.load(urlRequest);
	}
	
	private function urlLoaderIOError(e:IOErrorEvent):Void
	{
		cleanupUrlLoader();
		
		var event:Event = new Event( Event.ERROR ); 
		dispatchEvent( event );
	}
	
	private function urlLoaderComplete(_)
	{
		bytes = urlLoader.data;
		bytes.position = 0;
		onComplete();
	}
	
	private function onComplete()
	{
		cleanupUrlLoader();
		
		bytes.clear();
		bytes = null;
		
		var event:Event = new Event( Event.COMPLETE ); 
		dispatchEvent( event );
	}
	
	private function cleanupUrlLoader():Void
	{
		urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderComplete );
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
		urlLoader.close();
		urlLoader.data = null;
		urlLoader = null;
	}
}
