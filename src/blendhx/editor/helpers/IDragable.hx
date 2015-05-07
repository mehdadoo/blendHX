package blendhx.editor.helpers;

import flash.display.BitmapData;

interface IDragable extends IDragTarget
{
	public var dragGraphic:BitmapData;
	public var dragValue:Dynamic;
	public var dragText :String;
	public var dragType  :UInt;
}