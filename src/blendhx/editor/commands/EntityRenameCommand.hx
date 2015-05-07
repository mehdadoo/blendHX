package blendhx.editor.commands;

import blendhx.engine.components.IComposite;

import blendhx.editor.events.HierarchyEvent;

class EntityRenameCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		values.set("entity", model.selectedEntity);
		values.set("name", model.selectedEntity.name);
		
		var hierarchyEvent:HierarchyEvent = cast event;
		model.selectedEntity.name = hierarchyEvent.entityName;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var entity:IComposite = values.get("entity");
		var name:String = values.get("name");
		
		entity.name = name;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		var entity:IComposite = values.get("entity");
		var hierarchyEvent:HierarchyEvent = cast event;
		entity.name = hierarchyEvent.entityName;
		
		super.redo();
	}
}