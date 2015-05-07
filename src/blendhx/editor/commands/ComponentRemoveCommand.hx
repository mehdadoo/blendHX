package blendhx.editor.commands;

import blendhx.engine.components.IComponent;
import blendhx.engine.components.IComposite;
import blendhx.editor.events.ComponentEvent;

class ComponentRemoveCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var componentEvent:ComponentEvent = cast event;
		
		var component:IComponent = componentEvent.component;
		
		values.set("component", component);
		values.set("parent", component.parent);
		
		component.parent.removeChild(component);
		//component.dispose();
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var component:IComponent = values.get("component");
		var parent:IComposite = values.get("parent");
		
		parent.addChild(component);
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
	}
}