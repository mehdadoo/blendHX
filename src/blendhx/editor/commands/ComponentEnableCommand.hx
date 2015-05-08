package blendhx.editor.commands;

import blendhx.engine.components.IComponent;
import blendhx.editor.events.ComponentEvent;

class ComponentEnableCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var componentEvent:ComponentEvent = cast event;
		var component:IComponent = componentEvent.component;
		
		values.set("component", component);
		component.enabled = !component.enabled;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var component:IComponent = values.get("component");
		component.enabled = !component.enabled;
		
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
}