package blendhx.engine.loaders;

import blendhx.engine.events.IEventDispatcher;

interface ILoader extends IEventDispatcher
{
	public var data:Dynamic;
	public  var file:String;
	public var folder:String;
	
	public function load():Void;
}
