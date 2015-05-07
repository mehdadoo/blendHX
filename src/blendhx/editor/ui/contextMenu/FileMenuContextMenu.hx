package blendhx.editor.ui.contextMenu;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;
import blendhx.editor.events.ProjectEvent;

import flash.desktop.NativeApplication;

class FileMenuContextMenu extends ContextMenu
{
	public function new() 
	{
		super();
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("New project", 0, newProject, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.NEW_PROJECT);
		new ContextMenuButton("Open project", 0, openProject, this, 1, 1,
							  ControlBase.ROUND_NONE);
		new ContextMenuButton("Save                   Ctrl + S", 0, save, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.SAVE);
							  
		addUIComponent( new Seperator() );
		
		new ContextMenuButton("Export .swf", 0, exportSWF, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.NONE);
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("Exit", 0, exitApplication, this, 1, 1,
							  ControlBase.ROUND_NONE, ImageButton.EXIT);
		addUIComponent( new Seperator() );
	}
	
	private function exportSWF()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.EXPORT_SWF);
		dispatchEvent(e);
		//e.dispose();
		
		dispose();
	}
	
	private function newProject()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.NEW);
		dispatchEvent(e);
		//e.dispose();
		
		dispose();
	}
	
	private function openProject()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.OPEN);
		dispatchEvent(e);
		//e.dispose();
		
		dispose();
	}
	private function save()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.SAVE);
		dispatchEvent(e);
		//e.dispose();
		
		dispose();
	}
	

	private function exitApplication()
	{
		dispose();
		
		NativeApplication.nativeApplication.exit();
	}

}