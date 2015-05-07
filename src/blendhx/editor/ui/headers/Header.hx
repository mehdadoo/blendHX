package blendhx.editor.ui.headers;

import blendhx.editor.mvc.IModel;
import blendhx.editor.mvc.IView;
import blendhx.editor.mvc.UICompositeView;

import flash.display.Graphics;
import flash.display.Sprite;

class Header extends UICompositeView
{
	private var color :UInt = 0x727272;
	
	public function new(model:IModel) 
	{
		super();
		
		padding = 5;
		this.model = model;
		this._height = 25;
	}
	
	public function redraw()
	{
		var g:Graphics = graphics;
		g.clear();
		g.beginFill( color );
		g.drawRect (1, 1, _width - 2, _height-1);
		g.endFill();
		
		g.lineStyle(1, 0xbbbbbb, 0.5);
		g.moveTo (0, _height);
		g.lineTo (_width, _height);
	}
	
	override public function resize()
	{
		repositionUIComponents();

		redraw();
		
		super.resize();
	}

	public function repositionUIComponents():Void
	{
		if (uiComponents.length >= 1)
			uiComponents[0].x = padding;

		if (uiComponents.length > 1)
		{
			for (i in 1...uiComponents.length)
			{
				uiComponents[i].x = uiComponents[i-1]._width + uiComponents[i-1].x + padding;
			}
		}
	}
}