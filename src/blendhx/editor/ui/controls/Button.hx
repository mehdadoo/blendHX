package blendhx.editor.ui.controls;


import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;

class Button extends ControlBase
{
    var normal:Array<UInt> = [0xa6a6a6, 0x8c8c8c];
    var over:Array<UInt> = [0xb3b3b3, 0x9b9b9b];
    var click:Array<UInt> = [0x565656, 0x6f6f6f];
	
	
	override public function resize():Void
	{  
		super.resize();
		redrawBox(normal);
	}
	
    override function onMouseOut(e:MouseEvent) {  redrawBox(normal);  }
    override function onMouseOver(e:MouseEvent){  redrawBox( over );  }
    override function onMouseUp(e:MouseEvent)  {  redrawBox(normal);  }
    override function onMouseDown(e:MouseEvent)
    {
		focus();
		
    	if (onChange != null && enabled) onChange();
		
    	redrawBox(click);
    }

    override function redrawBox(state:Array<UInt>)
    {
    	var g:Graphics = graphics;
    	var m:Matrix = new Matrix();
		
    	m.createGradientBox(_width * 2, 20, 90);
		
		if(!enabled)
		{
			
			alpha = 0.75;
			state = click;
		}
		
    	g.clear();
    	g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		
		
		
    	g.lineStyle(1, 0x393939, 1, true);
		
    	if (rounding == ControlBase.ROUND_BOTH)
		{
    		g.drawRoundRect(0, 0, _width, 20, 10);
		}
		else if (rounding == ControlBase.ROUND_LEFT)
		{
    		g.drawRoundRectComplex(0, 0, _width + container.padding / 2, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		}
		else if (rounding == ControlBase.ROUND_RIGHT)
		{
    		g.drawRoundRectComplex(-container.padding / 2, 0, _width + container.padding / 2, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		}
		else if (rounding == ControlBase.ROUND_NONE)
		{
    		g.drawRect(- container.padding / 2, 0, _width + container.padding, 20);
		}

    	g.endFill();
    }

    override public function dispose()
    {
    	normal = null;
    	over = null;
    	click = null;
    	super.dispose();
    }
}
