package blendhx.editor.commands;

import blendhx.engine.components.Camera;

import blendhx.editor.events.CameraEvent;

class CameraChangeCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var cameraEvent:CameraEvent = cast event;
		var camera:Camera = cameraEvent.camera;
		
		values.set("fov", camera.fov);
		values.set("near", camera.near);
		values.set("far", camera.far);
		
		camera.fov  = cameraEvent.fov;
		camera.near = cameraEvent.near;
		camera.far  = cameraEvent.far;
		
		camera.resize();
		
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var cameraEvent:CameraEvent = cast event;
		var camera:Camera = cameraEvent.camera;
		
		camera.fov  = values.get("fov");
		camera.near = values.get("near");
		camera.far  = values.get("far");
		
		model.selectedEntity = model.selectedEntity;
		
		camera.resize();
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
	
	
}