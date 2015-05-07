package blendhx.editor.mvc;

import blendhx.editor.events.HierarchyEvent;
import blendhx.editor.events.AssetsEvent;
import blendhx.editor.ui.HierarchyItem;
import blendhx.editor.ui.FileItem;
import blendhx.editor.ui.UIComponent;
import blendhx.editor.ui.controls.TextInput;
import blendhx.editor.ui.controls.ControlBase;

import blendhx.editor.helpers.ObjectType;

import flash.geom.Point;

class RenameView extends UICompositeView
{
	private var renameInput:TextInput;
	
	public function new( model:IModel ) 
	{
		super();
		this.model = model;
		
		renameInput = new TextInput( "", 0, rename, null, ControlBase.FIXED_WIDTH);
	}
	
	override public function update():Void
	{
		if( isEntity() )
			showEntityRenameBox();
		else
			showAssetRenameBox();
			
		renameInput.resize();
		renameInput.focus();
		addChild( renameInput );
	}
	
	private function isEntity():Bool
	{
		return model.lastSelectedObject == ObjectType.ENTITY;
	}
	
	private function showEntityRenameBox()
	{
		var topLeftStage:Point = model.selectedHierarchyItem.localToGlobal(new Point(0, 0));
		
		renameInput.x = 1;
		renameInput._width = model.selectedHierarchyItem._width - 2;
		renameInput.y = topLeftStage.y;
		renameInput.value = model.selectedEntity.name;
	}
	
	private function showAssetRenameBox()
	{
		var topLeftStage:Point = model.selectedFileItem.localToGlobal(new Point(0, 0));
		
		renameInput.x = topLeftStage.x - 2;
		renameInput._width = FileItem.colomnWidth - 12;
		renameInput.y = topLeftStage.y;
		renameInput.value = model.selectedFileItem.file.name;
	}
	
	private function rename():Void
	{
		if( !contains(renameInput) )
			return;
			
		removeChild( renameInput );
		
		if( isEntity() )
			renameEntity();
		else
			renameAsset();
	}
	
	private function renameEntity()
    {		
		var e:HierarchyEvent = new HierarchyEvent(HierarchyEvent.RENAME);
		e.entityName = renameInput.value;
		dispatchEvent(e);
		//e.dispose();
    }
	private function renameAsset()
    {		
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.RENAME);
		e.fileName = renameInput.value;
		dispatchEvent(e);
		//e.dispose();
    }
}