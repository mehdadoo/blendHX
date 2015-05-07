package blendhx.editor.ui.panels;

import blendhx.engine.components.Camera;

import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.events.CameraEvent;


class CameraPanel extends Panel
{
	private var fov_input :NumberInput;
	private var near_input:NumberInput;
	private var far_input :NumberInput;
	
	public function new() 
	{
		super("Camera", 200, true, true);
	}
	
	override private function initialize()
	{
		
		
		new Label( "Field Of View:" , 30, null, this, 2, 2);
		new Label("Clipping Planes:", 30, null, this, 1, 2);
		
		fov_input  = new NumberInput("fov" , 50, updateModel, this, 2, 2, NumberInput.ROUND_BOTH);
		near_input = new NumberInput("near", 50, updateModel, this, 1, 2, NumberInput.ROUND_UP  );
		far_input  = new NumberInput("far" , 70, updateModel, this, 1, 2, NumberInput.ROUND_DOWN);
	}	
	
	override public function update()
	{
		var camera:Camera = cast component;
		
		fov_input.value  = camera.fov;
		near_input.value = camera.near;
		far_input.value  = camera.far;
	}
	
	override private function updateModel() 
	{
		var e:CameraEvent = new CameraEvent( CameraEvent.CHANGE );
		e.camera = cast component;
		e.fov  = fov_input.value;
		e.near = near_input.value;
		e.far  = far_input.value;
		
		dispatchEvent( e );
	}
}