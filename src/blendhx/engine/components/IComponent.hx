package blendhx.engine.components;

import blendhx.engine.events.IEventDispatcher;

interface IComponent extends IEventDispatcher
{
	public var transform:Transform;
	
	@:isVar public var name(get, set):String;
	@:isVar public var parent(get, set):IComposite;
	@:isVar public var enabled(get, set):Bool;
	
	public function clone():IComponent;
	public function update():Void;
	public function initialize():Void;
	public function uninitialize():Void;
	public function dispose():Void;
}