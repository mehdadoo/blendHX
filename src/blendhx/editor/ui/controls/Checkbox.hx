package blendhx.editor.ui.controls;


import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.geom.Matrix;


class Checkbox extends ControlBase
{
	public static var Images:BitmapData = new blendhx.editor.ui.embeds.Images.CheckboxImages(0, 0);
	
	private var checked:Array<UInt> = [32];
	private var unchcked:Array<UInt> = [0];

	override public function createLabel() 
	{
		super.createLabel();
		label.x = 20;
		label.autoSize = TextFieldAutoSize.LEFT;
	}	
	
	
	override public function initialize() 
	{
		value = false;
	}
	
	override private function onMouseOut (e:MouseEvent){ redrawBox( checked  );  }
	override private function onMouseOver(e:MouseEvent){ redrawBox( unchcked );  }
	override private function onMouseUp  (e:MouseEvent){ redrawBox( checked  );  }
	override private function onMouseDown(e:MouseEvent)
	{	
		focus();
		value = !value;
		redrawBox( checked  );
		if (onChange != null) onChange();
	}
	
	override public function set_value(param:Dynamic) 
	{
		value = param;
		redrawBox( checked  );
		return param; 
	}

	override private function redrawBox(state:Array<UInt>)
	{
		if(value == true)
			state = [16];
		
		var matrix:Matrix = new Matrix();
  		matrix.translate(state[0], 0);
		
		
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(Checkbox.Images, matrix);
		g.drawRect(0, 0, 16, 16);
		g.endFill();
	}
	
	override public function resize()
	{
		if(container != null)
			super.resize();
	}
	
	override public function dispose()
	{
		checked  = null;
		unchcked = null;
		super.dispose();
	}

}