package blendhx.engine.assets;

import blendhx.engine.events.Event;
import blendhx.engine.events.EventDispatcher;

import flash.utils.ByteArray;


class Sound extends EventDispatcher implements IAsset
{
	public var sourceURL:String;
	public var id:UInt = 0;
	public var bytes:ByteArray;
	
	public function initialize( assets:Assets = null ):Void
	{
		dispatchEvent( new Event(Event.INITIALIZED) );
	}
	
	
	public function uninitialize():Void{}
	override public function dispose():Void
	{
		bytes.clear();
		bytes = null;
		super.dispose();
	}
}