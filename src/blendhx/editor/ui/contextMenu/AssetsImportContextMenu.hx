package blendhx.editor.ui.contextMenu;

import blendhx.editor.events.AssetsEvent;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;

import flash.net.URLRequest;

class AssetsImportContextMenu extends ContextMenu
{
	public function new() 
	{
		super();
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("Mesh        (.obj)", 0, importMesh, this ,1 ,1 ,
							  ControlBase.ROUND_NONE, ImageButton.MESH);
		new ContextMenuButton("Texture     (.png)", 0, importTexture, this,1 ,1 ,
							  ControlBase.ROUND_NONE, ImageButton.TEXTURE);
		addUIComponent( new Seperator() );
	}
	
	private function importMesh():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.IMPORT_MESH);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	
	private function importTexture():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.IMPORT_TEXTURE);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
}