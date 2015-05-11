package blendhx.editor.commands;

import blendhx.engine.Scene;
import blendhx.engine.components.IComposite;
import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Scripts;

import flash.utils.ByteArray;
import flash.display3D.Context3D;

class ProjectPlayModeCommand extends Command
{
	override public function execute():Void
	{
		CommandWithUndo.locked = true;
		
		model.scene.removeChild( model.editorCamera );
		model.scene.removeChild( model.gridFloor);
		model.scene.removeChild( model.transformGizmo);
		
		var original = model.scene.entities;
		var clone:IComposite = cast model.entities.clone();
		
		model.savedEntities = original;
		model.scene.entities = clone;
		
		model.playMode = true;
		
		model.editModeSelectedEntity = model.selectedEntity;
		model.selectedEntity = model.entities;
		model.transformGizmo.transform = model.selectedEntity.transform;
		
		
		
		super.execute();
	}
}