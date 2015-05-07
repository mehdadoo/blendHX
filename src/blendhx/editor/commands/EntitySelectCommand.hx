package blendhx.editor.commands;

import blendhx.engine.components.IComposite;
import blendhx.editor.events.HierarchyEvent;

class EntitySelectCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		if(model.focusedControlBase != null)
			model.focusedControlBase.unfocus();
			
		var hierarchyEvent:HierarchyEvent = cast event;
		
		values.set("selectedEntity", model.selectedEntity);
		model.selectedEntity = hierarchyEvent.entity;
			
		super.execute();
	}
	
	override public function undo():Void
	{
		values.set("entity", model.selectedEntity);
		model.selectedEntity = values.get("selectedEntity");
		super.undo();
	}
	
	override public function redo():Void
	{
		var hierarchyEvent:HierarchyEvent = cast event;
		model.selectedEntity = values.get("entity");

		super.redo();
	}
}