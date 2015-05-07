package blendhx.editor.commands;

import blendhx.engine.components.Script;

import blendhx.editor.events.ScriptEvent;

class ScriptChangeCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var scriptEvent:ScriptEvent = cast event;
		var script:Script = cast scriptEvent.component;
		
		var length:Int =  scriptEvent.values.length  ;
		
		//undo setup
		for(key in script.properties.keys())
			values.set(key, script.properties.get(key));
		
		for (i in 0...length)
		{
			script.properties.set( scriptEvent.componentProperties[i*2], scriptEvent.values[i] );
		}
		
		model.selectedFileItem = model.selectedFileItem;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var scriptEvent:ScriptEvent = cast event;
		var script:Script = cast scriptEvent.component;
		
		//undo setup
		for(key in script.properties.keys())
			script.properties.set(key, values.get(key));
			
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
}