package blendhx.editor.commands;

import blendhx.engine.Scene;
import blendhx.engine.components.Entity;
import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Scripts;

import flash.utils.ByteArray;
import flash.display3D.Context3D;

class ProjectEditModeCommand extends Command
{
	override public function execute():Void
	{
		
		
		model.scene.entities = null;
		model.scene.entities = model.savedEntities;
		
		model.scene.addChild( model.editorCamera );
		model.scene.addChild( model.gridFloor);
		model.scene.addChild( model.transformGizmo);
		model.savedEntities = null;
		model.playMode = false;
		
		flash.system.System.pauseForGCIfCollectionImminent();
		
		model.selectedEntity = model.editModeSelectedEntity;
		model.transformGizmo.transform = model.selectedEntity.transform;
		
		CommandWithUndo.locked = false;
		
		super.execute();
	}
}