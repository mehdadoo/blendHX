package blendhx.editor.ui.headers;


import blendhx.editor.mvc.IModel;

import blendhx.editor.ui.UIComponent;
import blendhx.editor.ui.controls.HeaderButton;
import blendhx.editor.ui.contextMenu.ContextMenu;
import blendhx.editor.ui.contextMenu.AssetsImportContextMenu;
import blendhx.editor.ui.contextMenu.AssetsCreateContextMenu;

import flash.geom.Point;

class AssetsHeader extends Header
{
	private var createButton:UIComponent;
	private var importButton:UIComponent;
	
	public function new(model:IModel) 
	{
		super( model );
		
		createButton = new HeaderButton("Create", 3, openCreateMenu, this);
		importButton = new HeaderButton("Import", 3, openImportMenu, this);
		
		createButton._width = 50;
		importButton._width = 50;
		
	}
	private function openImportMenu()
	{
		var menu:ContextMenu = new AssetsImportContextMenu();
		
		var globalPoint:Point = importButton.localToGlobal(new Point(0, 0));
		menu.display(globalPoint.x , globalPoint.y + 22 );
	}
	
	private function openCreateMenu()
	{
		var menu:ContextMenu = new AssetsCreateContextMenu();
		
		var globalPoint:Point = createButton.localToGlobal(new Point(0, 0));
		menu.display(globalPoint.x , globalPoint.y + 22 );
	}
	
	override public function dispose():Void
	{
		createButton = null;
		importButton = null;
		super.dispose();
	}
}