package blendhx.editor.ui.contextMenu;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.ContextMenuButton;
import blendhx.editor.ui.controls.ImageButton;
import blendhx.editor.events.ProjectEvent;

import blendhx.editor.commands.CommandWithUndo;

class EditMenuContextMenu extends ContextMenu
{
	public function new() 
	{
		super();
		
		addUIComponent( new Seperator() );
		new ContextMenuButton("Undo                  Ctrl + Z" , 0, undo, this, 1, 1, ControlBase.ROUND_NONE).enabled = CommandWithUndo.undoAvailable();
		new ContextMenuButton("Redo                   Ctrl + Y", 0, redo, this, 1, 1, ControlBase.ROUND_NONE).enabled = CommandWithUndo.redoAvailable();
		addUIComponent( new Seperator() );
	}
	public function undo():Void
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.UNDO);
		dispatchEvent( e );
			
		dispose();
	}
	
	public function redo():Void
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.REDO);
		dispatchEvent( e );
			
		dispose();
	}
}