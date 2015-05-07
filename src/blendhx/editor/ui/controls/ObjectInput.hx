package blendhx.editor.ui.controls;

import blendhx.editor.assets.*;
import blendhx.editor.helpers.IDragable;
import blendhx.editor.helpers.IDragTarget;
import blendhx.editor.helpers.Dragable;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldType;
import flash.geom.Matrix;


class ObjectInput extends ControlBase implements IDragTarget
{
	public static var BLENDER:UInt = 0;
	public static var OTHERS:UInt = 1;
	public static var IMAGE:UInt = 2;
	public static var SCRIPT:UInt = 3;
	public static var AUDIO:UInt = 4;
	public static var FOLDER:UInt = 5;
	public static var BACK:UInt = 6;
	public static var AS:UInt = 7;
	public static var MATERIAL:UInt = 8;
	public static var MESH:UInt = 9;
	public static var ENTITY:UInt = 10;
	
	public static var Icons:BitmapData = new blendhx.editor.ui.embeds.Images.FileImages(0, 0);
	
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	
	private var icon:Sprite;
	
	public var dragItem:IDragable;
	public var dragType:UInt;
	
	public function new(text:String, y:Float, onChange:Void->Void, panel:UIComposite,
						column:UInt, totalColumns:UInt, rounding:Array<Float> = null, type:UInt = 1) 
	{
		dragType = type;
		
		super(text, y, onChange, panel, column, totalColumns, rounding);
		
	}
	
	override public function initialize() 
	{
		createIcon();
		value = text;
		this.mouseChildren = false;
	}
	
	override public function resize()
	{
		super.resize();
		redrawBox(normal);
		
		label.width = _width-40;
	}
	
	public function setDragItem(dragItem:IDragable):Void
	{
		value = dragItem.dragValue;
		if (onChange != null)
			onChange();
	}
	
	override public function onMouseOut(e:MouseEvent)
	{
		redrawBox(normal);
	}	

	override public function onMouseOver(e:MouseEvent)
	{
		redrawBox(over);
		
	}
	
	override public function onMouseUp(e:MouseEvent)
	{
		focus();
		
		redrawBox(over);
	}
	
	
	override public function set_value(param:Dynamic) 
	{
		if( label == null)
			return param;
			
		value = param;
			
		if(param == null)
			label.text = "";
		else
			label.text = param.toString();
		
		if(label.text == "[object Entity]")
			label.text = param.name;
		
		return param; 
	}


	override private function createLabel()
	{
		super.createLabel();
		
		label.width      = _width-40;
		label.x          = 20;
		label.selectable = false;
		label.type       = TextFieldType.INPUT;	
	}
	
	//on startup create the representing icon type
	private function createIcon()
	{
		icon = new Sprite();
		var g:Graphics = icon.graphics;
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(3 , 2 + (16 - dragType) * 16);
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(Icons, matrix);
		g.drawRect(3,2, 16, 16);
		g.endFill();

		addChild(icon);
	}
	//redrawing the pretty box beneath
	override private function redrawBox(state:Array<UInt>)
	{
		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		g.clear();
		m.createGradientBox(_width, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		g.drawRoundRect(0, 0, _width, 20, 10);
		g.endFill();
	}
	
	override public function dispose()
	{
		removeChild(icon);
		
		icon       = null;
		dragItem   = null;
		normal     = null;
		over       = null;
		
		super.dispose();
	}
}