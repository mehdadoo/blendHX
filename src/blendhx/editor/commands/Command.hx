package blendhx.editor.commands;

import blendhx.editor.mvc.IModel;
import blendhx.editor.events.DisposableEvent;

//abstract command class, should be subclassed
class Command implements ICommand
{
	private var model:IModel;
	private var event:DisposableEvent;
	
	public function new(model:IModel, event:DisposableEvent):Void
	{
		this.model = model;
		this.event = event;
	}
	
	public function execute():Void
	{
		dispose();
	}
	
	public function dispose():Void
	{
		event.dispose();
		event = null;
		model = null;
	}
}