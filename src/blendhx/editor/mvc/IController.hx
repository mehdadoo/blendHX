package blendhx.editor.mvc;

interface IController
{
	public var model:IModel;
	
	public function handleEvent(e:flash.events.Event):Void;
}