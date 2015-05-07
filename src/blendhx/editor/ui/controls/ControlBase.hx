package blendhx.editor.ui.controls;

import blendhx.editor.ui.ExtendedTextField;

import blendhx.editor.ui.UIComponent;
import blendhx.editor.events.ControlBaseEvent;

import flash.display.Sprite;
import flash.text.TextFormatAlign;
import flash.events.Event;
import flash.events.MouseEvent;

 
class ControlBase extends UIComponent
{
	public static var ROUND_LEFT:Array<Float> = [5, 0, 5, 0];
    public static var ROUND_BOTH:Array<Float> = [5, 5, 5, 5];
    public static var ROUND_RIGHT:Array<Float>= [0, 5, 0, 5];
    public static var ROUND_NONE:Array<Float> = [0, 0, 0, 0];
	public static var FIXED_WIDTH:UInt = 999;
	
	@:isVar public var value(get, set):Dynamic;
	
	public  var enabled     :Bool;
	public  var column      :UInt;
	public  var totalColumns:UInt;
	private var label       :ExtendedTextField;
	private var text        :String;
	private var onChange    :Void->Void;
	private var rounding    :Array<Float>;
	
	
	public function new(text:String, y:Float, onChange:Void->Void, container:UIComposite=null,
						column:UInt=1, totalColumns:UInt=1, rounding:Array<Float> = null) 
	{
		super();
		
		if(rounding == null)
			rounding = ROUND_BOTH;
		
		if(container != null)
			container.addUIComponent(this);
		
		this.enabled      = true;
		this.rounding     = rounding;
		this.y            = y;
		this.text         = text;
		this.onChange     = onChange;
		this.totalColumns = totalColumns;
		this.column       = column;
		
		createLabel();
		resize();
		initialize();
		
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver );
		addEventListener(MouseEvent.MOUSE_OUT,  onMouseOut );
		addEventListener(MouseEvent.MOUSE_UP,   onMouseUp );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);	
	}
	
	private function createLabel()
	{
		label = new ExtendedTextField( TextFormatAlign.CENTER, text);
		label.width  = _width;
		label.height = _height;

		addChild(label);
	}
	
	private function onMouseOut (e:MouseEvent){}
	private function onMouseOver(e:MouseEvent){}
	private function onMouseUp  (e:MouseEvent){}
	private function onMouseDown(e:MouseEvent){}
	private function redrawBox    (state:Array<UInt>){}
	private function initialize():Void{}
	public function get_value():Dynamic{return value;}
	public function set_value(param:Dynamic):Dynamic{value = param; return param;}
	public function unfocus():Void{}
	
	
	public function focus():Void
	{
		var e:ControlBaseEvent = new ControlBaseEvent( ControlBaseEvent.FOCUS) ;
		e.control = this;
		dispatchEvent( e );
		e.dispose();
	}
	
	override public function resize():Void
	{  
		if(column!=FIXED_WIDTH)
		{
			_width = GetControlWidth   ( this );
			x      = GetControlPosition( this );
		}
		
		label.width  = _width;
	}
	
	override public function dispose():Void
	{
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver );
		removeEventListener(MouseEvent.MOUSE_OUT,  onMouseOut );
		removeEventListener(MouseEvent.MOUSE_UP,   onMouseUp );
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		removeChild(label);
		
		enabled = false;
		label    = null;
		value    = null;
		onChange = null;
		rounding = null;
		
		super.dispose();
	}
	
	//little function to tell how wide should this element be in contrast with other elements in the current horrizontal row
	public inline static function GetControlWidth( control:ControlBase):Float
	{
		var totalColumns = control.totalColumns;
		var padding      = control.container.padding;
		var panelWidth   = control.container._width;
		
		return (panelWidth - (padding * (totalColumns +1))) / totalColumns;
	}
	
	
	//gives the automatic positioning of  this ui element according to the other elements in this row, padding included!
	public inline static function GetControlPosition( control:ControlBase ):Float
	{
		var column  = control.column;
		var padding = control.container.padding;
		var width   = control._width;
		
		return ( width * (column -1) ) + (column * padding);
	}
}