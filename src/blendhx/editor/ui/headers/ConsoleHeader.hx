package blendhx.editor.ui.headers;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.Button;
import blendhx.editor.mvc.IModel;

class ConsoleHeader extends Header
{
	var clearButton:ControlBase;
	
	public function new(model:IModel) 
	{
		super( model );
		
		clearButton = new Button("Clear", 3, clear, this, ControlBase.FIXED_WIDTH, 0);	
	}
	
	override public function resize()
	{
		super.resize();
		clearButton._width = 70;
		clearButton.resize();
	}
	
	private function clear()
	{
		
		haxe.Log.clear();
	}
}