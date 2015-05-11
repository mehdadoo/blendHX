package blendhx.editor.mvc;

import blendhx.editor.events.*;
import blendhx.editor.commands.*;
import blendhx.editor.helpers.ObjectType;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

class ShortcutController implements IController
{
	public var model:IModel;
	
	public function new(model:IModel):Void
	{
		this.model = model;
	}

	public function handleEvent(e:Event):Void
	{
		if( model.focusedControlBase != null)
			return;
			
		var command:ICommand = null;
		
		var keyboardEvent:KeyboardEvent = cast e;

		switch(keyboardEvent.keyCode)
		{
			case Keyboard.Z: 
				if( keyboardEvent.ctrlKey )
					if( CommandWithUndo.undoAvailable() )
						command = new ProjectUndoCommand( model, new ProjectEvent(ProjectEvent.UNDO) );
			case Keyboard.Y: 
				if( keyboardEvent.ctrlKey )
					if( CommandWithUndo.redoAvailable() )
						command = new ProjectRedoCommand( model, new ProjectEvent(ProjectEvent.REDO) );
			case Keyboard.S:
				if( keyboardEvent.ctrlKey )
						command = new ProjectSaveCommand( model, new ProjectEvent(ProjectEvent.SAVE) );
			case Keyboard.F5:
						command = new ProjectReloadScriptsCommand( model, new ProjectEvent(ProjectEvent.RELOAD_SCRIPTS) );
			case Keyboard.ESCAPE:
				if( model.playMode  )
						command = new ProjectEditModeCommand( model, new ProjectEvent(ProjectEvent.EDIT_MODE) );
			case Keyboard.P:
				if( keyboardEvent.ctrlKey )
					if( !model.playMode  )
						command = new ProjectPlayModeCommand( model, new ProjectEvent(ProjectEvent.PLAY_MODE) );
			case Keyboard.F1:
						command = new ProjectHelpCommand( model, new ProjectEvent(ProjectEvent.HELP) );
			case Keyboard.F2:
					if( model.lastSelectedObject == ObjectType.ENTITY )
					{
						var e:HierarchyEvent = new HierarchyEvent(HierarchyEvent.RENAME_REQUEST);
						flash.Lib.current.stage.dispatchEvent( e );
					}
					else
					{
						var e:AssetsEvent = new AssetsEvent(AssetsEvent.RENAME_REQUEST);
						e.fileItem = model.selectedFileItem;
						flash.Lib.current.stage.dispatchEvent( e );
					}
			case Keyboard.DELETE:
				if( model.lastSelectedObject == ObjectType.ENTITY )
					command = new EntityDeleteCommand( model, new HierarchyEvent(HierarchyEvent.DELETE) );
			case Keyboard.D:
				if( keyboardEvent.shiftKey )
					if( model.lastSelectedObject == ObjectType.ENTITY )
						command = new EntityDeleteCommand( model, new HierarchyEvent(HierarchyEvent.DUPLICATE) );
			case Keyboard.NUMPAD_DECIMAL, Keyboard.F:
					command = new ViewportFocusCommand( model, new HierarchyEvent(HierarchyEvent.SELECT) );
			default:
				command = null;
		}

		if( command!=null )
			command.execute();
	}
}