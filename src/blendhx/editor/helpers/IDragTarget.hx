package blendhx.editor.helpers;

interface IDragTarget
{
	public var dragType:UInt;
	
	public function setDragItem(dragItem:IDragable):Void;
}