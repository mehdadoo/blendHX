package blendhx.editor.ui.panels;


import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.FileItem;

class AssetInfoPanel extends Panel
{
	var fileName:Label;
	var fileSize:Label;
	
	public function new() 
	{
		super("Asset Info", 200, false, false);
	}
	
	override private function initialize()
	{
		new Label( "File Name:" , 30, null, this, 1, 2);
		new Label( "File Size:" , 50, null, this, 1, 2);
		
		fileName = new Label( "Clipping Planes:", 30, null, this, 2, 2);
		fileSize = new Label( "Clipping Planes:", 50, null, this, 2, 2);
	}	
	
	override public function update()
	{
		var fileItem:FileItem = model.selectedFileItem;
		
		fileName.value = fileItem.file.name;
		fileSize.value = Math.ceil(fileItem.file.size / 1024) + " kb";
	}
}