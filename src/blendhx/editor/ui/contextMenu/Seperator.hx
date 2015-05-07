package blendhx.editor.ui.contextMenu;

import blendhx.editor.ui.UIComponent;

import flash.display.Graphics;

class Seperator extends UIComponent
{
	public function new()
	{
		super();
		_height = 5;
	}
	override public function resize():Void
	{
		
		_width = container._width;
		
		redraw();
	}
	
	private function redraw():Void
	{
		var g:Graphics = graphics;
		graphics.clear();
		
		g.lineStyle( 1 , 0xffffff, .1);
		g.moveTo   ( 1 , 3);
		g.lineTo   (_width-1, 3);
	}
}