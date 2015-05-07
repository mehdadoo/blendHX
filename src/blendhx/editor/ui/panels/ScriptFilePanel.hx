package blendhx.editor.ui.panels;

import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.controls.TextBox;
import blendhx.editor.ui.FileItem;

import flash.filesystem.FileStream;
import flash.filesystem.FileMode;

class ScriptFilePanel extends Panel
{
	private var fileName:Label;
	private var scriptView:TextBox;
	
	public function new() 
	{
		super("Asset Info", 200, false, false);
	}
	
	override private function initialize()
	{
		
		new Label( "File Name:" , 30, null, this, 1, 2);
		fileName = new Label( "Clipping Planes:", 30, null, this, 2, 2);
		
		scriptView = new TextBox( "script" , 50, null, this, 1, 1);
	}	
	
	override public function update()
	{
		var fileItem:FileItem = model.selectedFileItem;
		
		fileName.value = fileItem.file.name;
		
		var fs:FileStream = new FileStream();
		fs.open(fileItem.file, FileMode.READ);
		var s:String = fs.readUTFBytes( fs.bytesAvailable );
		fs.close();
		
		scriptView.value = s;
	}
	
	override public function resize()
	{
		super.resize();
		
		if(container!=null)
			scriptView._height = container._height - padding - scriptView.y;
		
		scriptView.resize();
	}
}