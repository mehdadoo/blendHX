package blendhx.editor.ui.controls;


import flash.display.Sprite;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.Lib;

class TextInput extends ControlBase
{
	
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var click:Array<UInt> = [0x868686, 0x969696];
	
	private var editing:Bool;
	
	
	override public function initialize() 
	{
		value = text;
		this.mouseChildren = false;
		
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		label.addEventListener(Event.CHANGE, updateValue);
		
		updateValue(null);
	}
	
	override private function createLabel()
	{
		super.createLabel();
		
		label.width = _width-40;
		label.x = 5;
		label.selectable = false;
		
		label.type = TextFieldType.INPUT;
	}

	override private inline function redrawBox(state:Array<UInt>)
	{
		if (editing)
		{
			state = click;
		}

		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		g.clear();
		m.createGradientBox(_width, _height, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		g.drawRoundRect(0, 0, _width, _height, 10);
		g.endFill();
	}
	
	override private function onMouseOut (e:MouseEvent){ redrawBox(normal); }
	override private function onMouseOver(e:MouseEvent){ redrawBox(over  ); }
	override private function onMouseUp  (e:MouseEvent){ redrawBox(normal); }
	override private function onMouseDown(e:MouseEvent)
	{	
		focus();
		
		
		
	}
	
	//we can now make the text selectable safely. if we did it earlier, a nasty system context menu would pop up on Assets panel
	private function setLabelToSelectable(e:TimerEvent)
	{
		var t:Timer = cast(e.target, Timer);
		t.removeEventListener(TimerEvent.TIMER, setLabelToSelectable);
		t.stop();
		t = null;
		
		
		flash.Lib.current.stage.focus = label;
		editing = true;
		label.text = value;
		label.selectable = true;
		label.setSelection(0, label.length);
		redrawBox(click);
		
		super.focus();
	}
	
	private function onKeyDown(e:KeyboardEvent)
	{
		if (e.keyCode == Keyboard.ENTER)
		{
			unfocus();
		}
	}
	
	//a little setter of the value
	override public function set_value(param:Dynamic):Dynamic
	{
		if(editing)
			return null;
		
		if(param == null)
			return null;
		
		value = param;
		label.text = value;
		
		return param; 
	}
	
	
	override public function resize()
	{
		super.resize();
		
		redrawBox(normal);
		
		label.width = _width-10;
		label.height = _height;
		//updateValue(null);
	}
	
	override public function focus()
	{
		//to avoid textField right click menu to popup, add a timer to do make text selectable few moments later
		var t:Timer = new Timer(0.1, 1);
		t.addEventListener(TimerEvent.TIMER, setLabelToSelectable);
		t.start();
	}
	
	override public function unfocus():Void
	{
		editing = false;
		updateValue(null);
		redrawBox(normal);
		label.selectable = false;
		label.setSelection(0, 0);
		
		if( onChange!=null )
			onChange();
			
		super.unfocus();
	}
	
	public function updateValue(_)
	{
		value = label.text;
	}

	
	override public function dispose()
	{
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		label.removeEventListener(Event.CHANGE, updateValue);
		
		normal = null;
		over   = null;
		click  = null;
	
		super.dispose();
	}
}