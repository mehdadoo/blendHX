package blendhx.editor.mvc;

interface IView
{
	public var model:IModel;
	public function update():Void;
}