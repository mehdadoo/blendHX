package blendhx.editor.helpers;

import flash.display.BitmapData;

class Dragable implements IDragable
{
	public var dragGraphic:BitmapData;
	public var dragValue:Dynamic;
	public var dragText :String="";
	public var dragType :UInt;
	
	public function setDragItem(dragItem:IDragable):Void
	{
		
	}
}