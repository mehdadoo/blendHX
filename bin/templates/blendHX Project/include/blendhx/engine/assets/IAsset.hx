package blendhx.engine.assets;

import blendhx.engine.events.IEventDispatcher;

interface IAsset extends IEventDispatcher
{
	public var sourceURL:String;
	public var id:UInt;
	
	public function initialize( assets:Assets = null ):Void;
	public function uninitialize():Void;
	public function dispose():Void;
}
