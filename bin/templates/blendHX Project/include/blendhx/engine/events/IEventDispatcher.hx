package blendhx.engine.events;

interface IEventDispatcher
{
	private var eventParent:IEventDispatcher;
	
	public function dispatchEvent( event:Event ):Void;
	public function addEventListener( type:String, listener:Event->Void ):Void;
	public function removeEventListener( type:String ):Void;
	public function dispose():Void;
}