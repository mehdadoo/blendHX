package blendhx.editor.ui;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;


class RemoveButton extends Sprite
{
	public static var Image:BitmapData = new blendhx.editor.ui.embeds.Images.RemoveImage(0, 0);
	
	private var onClick:Void->Void;
	
	public function new(onClick:Void->Void) 
	{
		super();
		this.onClick = onClick;
		
		createGraphic();
		
		addEventListener(MouseEvent.CLICK, removeComponent );
	}
	
	private function removeComponent(_)
	{
		onClick();
	}
	
	private function createGraphic()
	{
		
		var matrix:Matrix = new Matrix();
		
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(RemoveButton.Image, matrix);
		g.drawRect(0, 0, 16, 16);
		g.endFill();
	}

}