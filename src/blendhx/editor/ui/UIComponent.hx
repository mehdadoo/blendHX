package blendhx.editor.ui;

import flash.display.Sprite;

class UIComponent extends Sprite
{
	public  var container:UIComposite;
	
	public  var padding:UInt  = 10;
	public  var _width :Float = 40;
	public  var _height:Float = 20;
	
	public function resize():Void{}
	public function dispose():Void
	{
		container = null;
	}
}