package blendhx.editor.commands;

import blendhx.editor.mvc.IModel;

interface ICommand
{
	private var model:IModel;
	
	public function execute():Void;
	public function dispose():Void;
}