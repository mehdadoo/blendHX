package blendhx.editor.ui.contextMenu;
import flash.filters.DropShadowFilter;


import flash.Lib;
import flash.display.Graphics;
import flash.events.MouseEvent;

class ContextMenu extends UIComposite
{
	private var color :UInt = 0x161616;
	
	private static var currentMenu:ContextMenu;
	
	public function new(  )
	{
		super();
		
		padding = 0;
		_width  = 150;
		
		var shadow:DropShadowFilter = new DropShadowFilter();
		shadow.blurX = 10;
		shadow.blurY = 10;
		shadow.strength = .7;
		this.filters = [shadow];
	}
	
	public function display(_x:Float, _y:Float)
	{
		if(ContextMenu.currentMenu!=null)
			return;
		
		ContextMenu.currentMenu = this;
		
		Lib.current.stage.addChild( this );
		Lib.current.stage.addEventListener( MouseEvent.MOUSE_OUT, performRemoveCheck);
		
		x = _x;
		y = _y;
		
		resize();
		
		if(y + _height > Lib.current.stage.stageHeight)
			y = Lib.current.stage.stageHeight - _height;
		if(x + _width > Lib.current.stage.stageWidth)
			x = Lib.current.stage.stageWidth - _width;
	}
	
	override public function resize()
	{
		repositionUIComponentsVertically();
		redraw();
		super.resize();
	}

	
	public function repositionUIComponentsVertically()
	{
		if (uiComponents.length >= 1)
			uiComponents[0].y = padding;

		if (uiComponents.length > 1)
		{
			for (i in 1...uiComponents.length)
			{
				uiComponents[i].y = padding + uiComponents[i-1]._height + uiComponents[i-1].y;
				_height = uiComponents[i].y + uiComponents[i]._height + padding;
			}
		}
		
	}
	
	public function redraw()
	{
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(    1, 0, 1);
		g.beginFill( color, 0.7 );
		g.drawRoundRect(0, 0, _width, _height, 8);
		g.endFill();
	}
				
	private function performRemoveCheck(e:MouseEvent):Void
	{
		if(this.hitTestPoint(e.stageX, e.stageY))
			return;
		
		dispose();
	}
			
	override public function dispose():Void
	{
		ContextMenu.currentMenu = null;
		Lib.current.stage.removeEventListener( MouseEvent.MOUSE_OUT, performRemoveCheck);
		Lib.current.stage.removeChild( this );
		filters = [];
		super.dispose();
	}

}