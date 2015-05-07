package blendhx.editor.mvc;

import blendhx.editor.events.HierarchyEvent;
import blendhx.editor.mvc.IController;
import blendhx.editor.helpers.IDragable;
import blendhx.editor.helpers.IDragTarget;
import blendhx.editor.ui.HierarchyItem;

import flash.Lib;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;


class DragController implements IController
{
	private var dragSprite:Sprite;
	private var dragBitmap:Bitmap;
	
	public var model:IModel;
	
	public function new( model:IModel ) 
	{
		this.model = model;
		
		Lib.current.stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp);
		
		dragSprite = new Sprite();
		var bitmapData:BitmapData = new BitmapData(200,20, true,0x00FFFFFF);
		dragBitmap = new Bitmap( bitmapData );
		dragBitmap.x=3;
		dragBitmap.y=3;
		dragSprite.addChild(dragBitmap);
	}	
	
	public function handleEvent(e:flash.events.Event):Void
	{
		if( !is(e.target, IDragable) )
			return;
		
		if( e.type == MouseEvent.MOUSE_DOWN )
			onDragableMouseDown( cast e );
		else if( e.type == MouseEvent.MOUSE_OUT )
			onHierarchyMouseOut( cast e );
	}
	
	private function onDragableMouseDown(e:MouseEvent):Void
	{
		model.dragItem = cast e.target;
	}
	
	private function onHierarchyMouseOut(e:MouseEvent):Void
	{
		var dragItem:IDragable = cast e.target;
		
		if( e.buttonDown && dragItem == model.dragItem)
			createDragGraphic();
	}
	
	private function onStageMouseUp(e:MouseEvent):Void
	{
		if( is( e.target, IDragTarget ) )
		{
			var dragTarget:IDragTarget  = cast e.target;
			
			if( model.dragItem != null && 
			   dragTarget != model.dragItem && 
			   dragTarget.dragType == model.dragItem.dragType )
			{
				dragTarget.setDragItem( model.dragItem );
			}
		}

		clearDrag();
	}

	private function is( object:Dynamic, classType:Class<Dynamic> ):Bool
	{
		return untyped __is__( object, classType);
	}
	
	public function createDragGraphic()
	{
		var bitmapData:BitmapData = dragBitmap.bitmapData;
		
		bitmapData.fillRect( new Rectangle(0, 0, 200, 20), 0x00FFFFFF );
		bitmapData.copyPixels( model.dragItem.dragGraphic, bitmapData.rect, new Point());
		
		dragSprite.startDrag(true);
		
		Lib.current.stage.addChild(dragSprite);
	}
	
	public function clearDrag( )
	{
		if(  Lib.current.stage.contains(dragSprite) )
		{
			Lib.current.stage.removeChild(dragSprite);
			dragSprite.stopDrag();
		}
		
		model.dragItem = null;
	}
}