package blendhx.editor.events;

class DisposableEvent extends flash.events.Event
{
	public function new(type:String):Void
	{
		super(type, true);
	}
	public function dispose():Void{}
}