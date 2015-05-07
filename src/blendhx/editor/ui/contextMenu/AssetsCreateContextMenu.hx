package blendhx.editor.ui.contextMenu;

import blendhx.editor.events.AssetsEvent;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;

import flash.net.URLRequest;

class AssetsCreateContextMenu extends ContextMenu
{
	
	public function new() 
	{
		super();
		
		_width = 180;
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("New Folder", 0, createNewFolder, this, 1, 1, 
							  ControlBase.ROUND_NONE, ImageButton.NEW_FOLDER);
		new ContextMenuButton("Material", 0, createMaterial, this, 1, 1, 
							  ControlBase.ROUND_NONE, ImageButton.MATERIAL);
		new ContextMenuButton("Shader", 0, createShader, this);
		
		addUIComponent( new Seperator() );
		
		new ContextMenuButton("Haxe Component", 0, createHaxeScript, this, 1, 1);
		new ContextMenuButton("ActionScript Component", 0, createActionScript, this, 1, 1).enabled = false;
		
		addUIComponent( new Seperator() );
	}
	
	private function createMaterial():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.CREATE_MATERIAL);
		dispatchEvent( e );
		e.dispose();
		
		dispose();
	}
	
	private function createNewFolder():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.CREATE_NEW_FOLDER);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	private function createShader():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.CREATE_SHADER);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	
	private function createHaxeScript():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.CREATE_HAXE_FILE);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	private function createActionScript():Void
	{
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.CREATE_ACTIONSCRIPT);
		dispatchEvent( e );
		//e.dispose();
		
		dispose();
	}
	
}