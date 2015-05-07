package blendhx.engine.systems;

import blendhx.engine.events.IEventDispatcher;
import blendhx.engine.Scene;
import blendhx.engine.Viewport;

import flash.display3D.Context3D;


interface IRenderingSystem extends IEventDispatcher
{
    public var context3D:Context3D;
	public var viewport:Viewport;
	public var scene:Scene;
	
    public function initialize():Void;
	public function resize():Void;
	public function update():Void;
}
