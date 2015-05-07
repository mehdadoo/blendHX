package blendhx.editor.ui.controls;



import flash.display.GradientType;
import flash.display.Graphics;
import flash.text.TextFieldAutoSize;
import flash.events.MouseEvent;
import flash.geom.Matrix;


class HeaderButton extends ControlBase
{
	private var normal:Array<UInt> = [0x727272, 0x727272];
	private var over:Array<UInt> = [0x567fc1, 0x567fc1];
	private var click:Array<UInt> = [0x567fc1, 0x567fc1];
	
	
	override private function onMouseOut (e:MouseEvent){ redrawBox(normal);  }
	override private function onMouseOver(e:MouseEvent){ redrawBox(over);    }
	override private function onMouseDown(e:MouseEvent)
	{	
		focus();
		if (onChange != null)
			onChange(); 
	}
	
	
	override public function resize()
	{
		label.width = _width;
		redrawBox(normal);
	}
		
	override private function redrawBox(state:Array<UInt>)
	{
		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		
		g.clear();
		m.createGradientBox(_width*2, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(0, 0, 0);
		g.drawRoundRect(0, 0, _width, 20, 12);
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