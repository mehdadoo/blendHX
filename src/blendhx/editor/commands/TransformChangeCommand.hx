package blendhx.editor.commands;

import blendhx.engine.components.Transform;

import blendhx.editor.events.TransformEvent;

class TransformChangeCommand extends CommandWithUndo
{
	
	override public function execute():Void
	{
		var transformEvent:TransformEvent = cast event;
		var transform:Transform = transformEvent.transform;
		
		values.set("x", transform.x);
		values.set("y", transform.y);
		values.set("z", transform.z);
		values.set("rotationX", transform.rotationX);
		values.set("rotationY", transform.rotationY);
		values.set("rotationZ", transform.rotationZ);
		values.set("scaleX", transform.scaleX);
		values.set("scaleY", transform.scaleY);
		values.set("scaleZ", transform.scaleZ);
		
		transform.x = transformEvent.x;
		transform.y = transformEvent.y;
		transform.z = transformEvent.z;
		transform.rotationX = transformEvent.rotationX;
		transform.rotationY = transformEvent.rotationY;
		transform.rotationZ = transformEvent.rotationZ;
		transform.scaleX    = transformEvent.scaleX;
		transform.scaleY    = transformEvent.scaleY;
		transform.scaleZ    = transformEvent.scaleZ;
		
		model.selectedEntity = model.selectedEntity;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var transformEvent:TransformEvent = cast event;
		var transform:Transform = transformEvent.transform;
		
		transform.x = values.get("x");
		transform.y = values.get("y");
		transform.z = values.get("z");
		transform.rotationX = values.get("rotationX");
		transform.rotationY = values.get("rotationY");
		transform.rotationZ = values.get("rotationZ");
		transform.scaleX = values.get("scaleX");
		transform.scaleY = values.get("scaleY");
		transform.scaleZ = values.get("scaleZ");
		
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
	}
}