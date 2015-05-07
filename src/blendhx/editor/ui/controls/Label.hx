package blendhx.editor.ui.controls;

import flash.text.TextFieldAutoSize;

class Label extends ControlBase
{
	
	override private function createLabel()
	{
		super.createLabel();
		label.autoSize = TextFieldAutoSize.LEFT;
	}
	
	override public function set_value(param:Dynamic):Dynamic
	{
		value = param;
		if(label!= null && param!= null)label.text = value;
		
		return param; 
	}
}