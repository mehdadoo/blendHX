package blendhx.editor.ui.controls;


import flash.display.Sprite;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.geom.Matrix;

class ImageButton extends Button
{
	public static var NEW_FOLDER:UInt = 0;
	public static var ADD:UInt = 1;
	public static var REMOVE:UInt = 2;
	public static var REFRESH:UInt = 3;
	public static var PLAY:UInt = 4;
	public static var ROTATE:UInt = 5;
	public static var TRANSFORM:UInt = 6;
	public static var SCALE:UInt = 7;
	public static var CONSOLE_PANEL:UInt = 8;
	public static var ASSETS_PANEL:UInt = 9;
	public static var FULL_SCREEN:UInt = 10;
	public static var STOP:UInt = 11;
	public static var NEW_PROJECT:UInt = 12;
	public static var SAVE:UInt = 13;
	public static var EXIT:UInt = 14;
	public static var FOLDER:UInt = 15;
	public static var MATERIAL:UInt = 16;
	public static var MESH:UInt = 17;
	public static var TEXTURE:UInt = 18;
	public static var WEBPAGE:UInt = 19;
	public static var FLASH:UInt = 20;
	public static var SOUND:UInt = 21;
	public static var NONE:UInt = 22;
	
	public static var Images:BitmapData = new blendhx.editor.ui.embeds.Images.ButtonImages(0, 0);
	
	private var icon:Sprite;

	public function new(text:String, y:Float, onChange:Void->Void, panel:UIComposite,
						column:UInt=1, totalColumns:UInt=1, rounding:Array<Float> = null, iconType:UInt = 22) 
	{
		super(text, y, onChange, panel, column, totalColumns, rounding);
		value = text;
		createIcon( iconType );
	}

	
	private function createIcon(type:UInt)
	{
		icon = new Sprite();
		
		var g:Graphics = icon.graphics;
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(0 ,  - (type * 16));
		g.beginBitmapFill(ImageButton.Images, matrix);
		g.drawRect(0,0, 16, 16);
		g.endFill();
		
		icon.x = 2;
		icon.y = 2;
		
		if(rounding == ControlBase.ROUND_LEFT)
			icon.x = (padding/2) + 1;
		else if(rounding == ControlBase.ROUND_RIGHT)
			icon.x = (padding/2) - 3;
		
		addChild(icon);
	}
	
	override private function createLabel()
	{
		super.createLabel();
		 
		label.width = _width - 10;
		label.x     = 10;
	}
	
	override public function resize():Void
	{  
		super.resize();
		label.width = _width - 10;
	}
	
	override public function dispose()
	{
		removeChild(icon);
		icon   = null;
		
		super.dispose();
	}
}