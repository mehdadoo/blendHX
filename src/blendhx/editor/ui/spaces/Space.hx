package blendhx.editor.ui.spaces;

import blendhx.editor.mvc.IModel;
import blendhx.editor.mvc.IView;
import blendhx.editor.mvc.UICompositeView;

import flash.display.Graphics;
import flash.display.Sprite;

class Space extends UICompositeView
{
	private var border:Sprite;
	private var color :UInt;
	private var header:UICompositeView;
	
	public function new(model:IModel, _width:Float, color:UInt = 0x727272) 
	{
		super();
		
		this.model = model;
		this._width = _width;
		this.color = color;
		
		this.padding = 20;
		
		border = new Sprite();
		
		redraw();
	}
	
	public function addHeader(header:UICompositeView):Void
	{
		this.header = header;
		addChild(header);
		header.y = 0;
	}
	public function redraw()
	{
		var g:Graphics;
		g = graphics;
		g.clear();
		g.beginFill( color );
		g.drawRect (0, 0, _width, _height);
		g.endFill();
		
		g = border.graphics;
		g.clear();
		
		g.lineStyle(1, 0x000000);
		g.drawRect (0, 0, _width, _height);
		g.endFill();
		
		g.lineStyle(1, 0xbbbbbb, 0.5);
		g.drawRect (1, 1, _width-2, _height-2);	
	}
	
	override public function resize()
	{
		if(header!=null)
		{
			header._width = _width;
			header.resize();
		}
			
		repositionUIComponents();

		redraw();
	
		addChild( border );
		
		
	}

	public function repositionUIComponents():Void
	{
		repositionUIComponentsVertically();
		for (uiComponent in uiComponents)
		{
			uiComponent._width = _width;
			uiComponent.resize();
		}
		repositionUIComponentsVertically();
	}

	public function repositionUIComponentsVertically()
	{
		var startY  :Float = 0;
		
		if(header!=null)
			startY = header._height;
		
		
		if (uiComponents.length >= 1)
			uiComponents[0].y = startY;

		if (uiComponents.length > 1)
		{
			for (i in 1...uiComponents.length)
			{
				uiComponents[i].y = startY + uiComponents[i-1]._height + uiComponents[i-1].y;
			}
		}
	}
				 
	override public function dispose()
	{
		if ( contains(border) )
			removeChild(border);
		
		if ( contains(header) )
			removeChild(header);
		
		header.dispose();
		header = null;
		border = null;
		
		super.dispose();
	}
}