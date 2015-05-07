package blendhx.editor.ui.contextMenu;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;

import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.AssetsEvent;

import flash.events.Event;


class FileItemContextMenu extends ContextMenu
{
	var fileItem:FileItem;
	
	public function new(fileItem:FileItem) 
	{
		super();
		
		this.fileItem = fileItem;
		
		addUIComponent( new Seperator() );
		
		new ContextMenuButton("Open", 0, openFile, this, 1, 1);
		new ContextMenuButton("Rename                      F2", 0, renameFile, this, 1, 1);
		new ContextMenuButton("Delete", 0, deleteFile, this, 1, 1, ControlBase.ROUND_NONE, ImageButton.REMOVE);

		addUIComponent( new Seperator() );
			
		resize();
	}
	
	private function openFile()
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.OPEN);
		e.fileItem = fileItem;
		dispatchEvent( e );
		//e.dispose();
			
		dispose();
	}
	
	private function deleteFile()
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.DELETE);
		e.fileItem = fileItem;
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	private function renameFile()
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.RENAME_REQUEST);
		e.fileItem = fileItem;
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	
	override public function dispose():Void
	{
		fileItem = null;
		super.dispose();
	}

}