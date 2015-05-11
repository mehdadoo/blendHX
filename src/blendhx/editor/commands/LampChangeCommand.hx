package blendhx.editor.commands;


import blendhx.engine.components.Lamp;
import blendhx.editor.events.LampEvent;

class LampChangeCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var lampEvent:LampEvent = cast event;
		var lamp:Lamp = lampEvent.lamp;
		
		values.set("energy", lamp.energy);
		values.set("shadow", lamp.shadow);
		
		lamp.energy = lampEvent.energy;
		lamp.shadow = lampEvent.shadow;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var lampEvent:LampEvent = cast event;
		var lamp:Lamp = lampEvent.lamp;
		
		lamp.energy = values.get("energy");
		lamp.shadow = values.get("shadow");
				
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
}