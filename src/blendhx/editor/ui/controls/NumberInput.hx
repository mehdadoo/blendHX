package blendhx.editor.ui.controls;


import blendhx.editor.helpers.Utils;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.text.TextFieldType;
import flash.geom.Matrix;
import flash.ui.Keyboard;



class NumberInput extends ControlBase
{
	
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var click:Array<UInt> = [0x868686, 0x969696];
	
	private var editing:Bool;
	

	public static var ROUND_UP:Array<Float>   = [13, 13, 0 , 0 ];
	public static var ROUND_DOWN:Array<Float> = [0 , 0 , 13, 13];
	public static var ROUND_BOTH:Array<Float> = [20, 20, 20, 20];
	public static var ROUND_NONE:Array<Float> = [0 , 0 , 0 , 0 ];
	
	override public function initialize() 
	{
		value = 0.0;
		
		this.mouseChildren = false;
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown   );
	}
	
	override public function resize()
	{
		super.resize();
		redrawBox(normal);
		
		label.width = _width-30;
	}
	
	override private function createLabel()
	{
		super.createLabel();	
		
		label.width = _width-30;
		label.x = 15;
		label.selectable = true;
		label.type = TextFieldType.INPUT;
	}
	
	override private function redrawBox(state:Array<UInt>)
	{
		if (editing)
		{
			state = click;
		}

		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		g.clear();
		m.createGradientBox(_width, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		g.drawRoundRectComplex(0, 0, _width, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		g.endFill();
		
		if (!editing)
		{
			redrawHandles();
		}
		
	}
	
	//drawing the increase and decrease graphics
	private function redrawHandles()
	{
		var g:Graphics = graphics;
		g.beginFill(0x767676);
		g.lineStyle(0, 0, 0);
		g.moveTo(8, 10);
		g.lineTo(12, 14);
		g.lineTo(12, 6);
		g.lineTo(8, 10);
		g.moveTo(_width-8, 10);
		g.lineTo(_width-12, 14);
		g.lineTo(_width-12, 6);
		g.lineTo(_width-8, 10);
		g.endFill();
	}
	
	override function onMouseOut(e:MouseEvent)
    {
    	redrawBox(normal);
    }

    override function onMouseOver(e:MouseEvent)
    {
    	redrawBox(over);
    }

    override function onMouseUp(e:MouseEvent)
    {
    	redrawBox(over);
    }
	//when mouse is down over this, if its presed at center, make the textfield inside editable, else increase or decrease value based on mouse position 
    override function onMouseDown(e:MouseEvent)
    {
		if (!editing && e.localX <  20)
		{
			super.focus();
			value --;
			updateValue();
			
		}
		else if (!editing && e.localX > _width - 20)
		{
			super.focus();
			value ++;
			updateValue();
			
		}
		else 
		{
			focus();
		}
		
    	redrawBox(click);
		
    }
	
	//a little value setter, and showing only 2 decimals of the float value
	override public function set_value(param:Dynamic) 
	{
		if(editing)
			return null;
			
		value = param;
		
		if(label != null)
			label.text = text+": "+ Utils.PrintFloat( param, 2 );
		return param; 
	}
	
	
	
	//when key is pressed and it's Enter, fix the value
	private function onKeyDown(e:KeyboardEvent)
	{
		if (e.keyCode == Keyboard.ENTER)
			unfocus();
	}
	
	override public function focus()
	{
		flash.Lib.current.stage.focus = label;
		editing = true;
		label.text = Utils.PrintFloat(value, 2);
		label.selectable = true;
		label.setSelection(0, label.length);
		redrawBox(click);
		
		super.focus();
	}

	override public function unfocus():Void
	{
		editing = false;
		updateValue();
		redrawBox(normal);
		label.selectable = false;
	}
	
	
	public function updateValue()
	{
		var newValue:Float = Std.parseFloat(label.text);
		if (Std.string(newValue)!="NaN")
		{
			value = newValue;
		}
		
		label.text = text+": "+ Utils.PrintFloat( value, 2 );
		if (onChange != null) onChange();
	}

	
	override public function dispose()
	{
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown   );
		
		normal = null;
		over = null;
		click = null;
		
		super.dispose();
	}
}