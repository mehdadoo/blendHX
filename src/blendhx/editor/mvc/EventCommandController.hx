package blendhx.editor.mvc;

import blendhx.editor.events.*;
import blendhx.editor.commands.*;

import flash.events.Event;

class EventCommandController implements IController
{
	public var model:IModel;
	
	public function new(model:IModel):Void
	{
		this.model = model;
	}

	public function handleEvent(e:Event):Void
	{
		var command:Class<Dynamic>;
		
		switch (e.type)
		{
			case ProjectEvent.UNDO:
				command = ProjectUndoCommand;
				
			case ProjectEvent.REDO:
				command = ProjectRedoCommand;
				
			case ControlBaseEvent.FOCUS:
				command = ControlBaseUnfocusCommand;
				
			case HierarchyEvent.SELECT:
				command = EntitySelectCommand;
				
			case HierarchyEvent.REPARENT:
				command = EntityReparentCommand;
				
			case HierarchyEvent.NEW:
				command = EntityNewCommand;
				
			case HierarchyEvent.DELETE:
				command = EntityDeleteCommand;
				
			case HierarchyEvent.RENAME:
				command = EntityRenameCommand;
				
			case ComponentEvent.NEW:
				command = ComponentNewCommand;

			case ComponentEvent.ENABLE:
				command = ComponentEnableCommand;
				
			case ComponentEvent.REMOVE:
				command = ComponentRemoveCommand;
				
			case TransformEvent.CHANGE:
				command = TransformChangeCommand;
			
			case SoundEvent.CHANGE:
				command = SoundChangeCommand;
				
			case CameraEvent.CHANGE:
				command = CameraChangeCommand;
			
			case ScriptEvent.CHANGE:
				command = ScriptChangeCommand;
				
			case MeshRendererEvent.CHANGE:
				command = MeshRendererChangeCommand;
				
			case MaterialEvent.CHANGE:
				command = MaterialChangeCommand;
			
			case AssetsEvent.RENAME:
				command = AssetsRenameCommand;
				
			case AssetsEvent.OPEN:
				command = AssetsOpenCommand;
				
			case AssetsEvent.SELECT:
				command = AssetsSelectCommand;
			
			case AssetsEvent.DELETE:
				command = AssetsDeleteCommand;
				
			case AssetsEvent.CREATE_NEW_FOLDER:
				command = AssetsNewFolderCommand;
				
			case AssetsEvent.CREATE_HAXE_FILE:
				command = AssetsNewHaxeFileCommand;
			
			case AssetsEvent.CREATE_SHADER:
				command = AssetsNewShaderCommand;
			
			case AssetsEvent.CREATE_MATERIAL:
				command = AssetsNewMaterialCommand;
			
			case AssetsEvent.IMPORT_MESH:
				command = AssetsImportMeshCommand;
			
			case AssetsEvent.IMPORT_TEXTURE:
				command = AssetsImportTextureCommand;
			
			case AssetsEvent.IMPORT_SOUND:
				command = AssetsImportSoundCommand;
				
			case ProjectEvent.REQUEST_LOAD_PROJECT:
				command = ProjectLoadCommand;
				
			case ProjectEvent.RELOAD_SCRIPTS:
				command = ProjectReloadScriptsCommand;
				
			case ProjectEvent.PLAY_MODE:
				command = ProjectPlayModeCommand;
				
			case ProjectEvent.EDIT_MODE:
				command = ProjectEditModeCommand;
				
			case ProjectEvent.SAVE:
				command = ProjectSaveCommand;
			
			case ProjectEvent.NEW:
				command = ProjectNewCommand;
				
			case ProjectEvent.OPEN:
				command = ProjectOpenCommand;
			
			case ProjectEvent.EXPORT_SWF:
				command = ProjectExportSWFCommand;
			
			case ProjectEvent.HELP:
				command = ProjectHelpCommand;
				
			default:
				trace("Unknown Event", 0xcc4400);
				return;
		}
		
		var commandInstance:ICommand = Type.createInstance( command, [model, e] );
		commandInstance.execute();
	}
}