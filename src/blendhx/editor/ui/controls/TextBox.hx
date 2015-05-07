package blendhx.editor.ui.controls;

import blendhx.editor.ui.ExtendedTextField;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;

class TextBox extends TextInput
{
	override private function createLabel()
	{
		label = new ExtendedTextField( TextFormatAlign.LEFT, text);
		label.width = _width - 40;
		label.x = 5;
		label.selectable = false;
		label.wordWrap = true;
		addChild(label);
	}

	override private function onMouseOver(e:MouseEvent){}
	override private function onMouseDown(e:MouseEvent){}
	
}