package blendhx.editor.commands;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Material;

import blendhx.editor.ui.FileItem;
import blendhx.editor.events.MaterialEvent;

class MaterialChangeCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var materialEvent:MaterialEvent = cast event;
		var material:Material = materialEvent.material;
		
		//undo setup
		 for(key in material.properties.keys())
			values.set(key, material.properties.get(key));
		values.set("shaderURL", material.shaderURL); 
		
		for(key in materialEvent.properties.keys())
			material.properties.set(key, materialEvent.properties.get(key));
		//replace all the material history of values
		//material.properties = materialEvent.properties; 
		material.shaderURL = materialEvent.shaderURL;
		material.initialize( model.assets );
		
		//model.selectedEntity = model.selectedEntity;
		
		super.execute();
	}
	
	
	override public function undo():Void
	{
		var materialEvent:MaterialEvent = cast event;
		var material:Material = materialEvent.material;
		
		for(key in material.properties.keys())
			material.properties.set(key, values.get(key));
		material.shaderURL = values.get("shaderURL");
		material.initialize( model.assets );
		
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
	} 
}