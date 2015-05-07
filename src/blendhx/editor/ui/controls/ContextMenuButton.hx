package blendhx.editor.ui.controls;

import flash.text.TextFormatAlign;
import flash.display.Graphics;

class ContextMenuButton extends ImageButton
{
	override private function initialize():Void
	{
		super.initialize();
		rounding = ControlBase.ROUND_NONE;
		over = [0x7aa3e5, 0x5680c1];
		
	}
	override private function createLabel()
	{
		super.createLabel();
		
		label.align = TextFormatAlign.LEFT;
		label.textColor = 0xffffff;
		label.x = 20;
	}
	
	override public function resize():Void
	{  
		super.resize();
		label.width = _width - label.x;
	}
	
	override function redrawBox(state:Array<UInt>)
    {
		if(!enabled)
		{
			if(label!= null)
				label.textColor = 0x666666;
			return;
		}
		if(state != over)
		{
			label.textColor = 0xffffff;
			graphics.clear();
			return;
		}
			
		label.textColor = 0;
		
		super.redrawBox( state );
	}
}