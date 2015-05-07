package blendhx.editor.ui.panels;

import blendhx.engine.components.Transform;

import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.events.TransformEvent;

class TransformPanel extends Panel
{
	var location_x:NumberInput;
	var location_y:NumberInput;
	var location_z:NumberInput;
	var rotation_x:NumberInput;
	var rotation_y:NumberInput;
	var rotation_z:NumberInput;
	var scale_x:NumberInput;
	var scale_y:NumberInput;
	var scale_z:NumberInput;
			
	public function new() 
	{
		super("Transform", 200, false, false);
	}
	
	override private function initialize()
	{
		new Label("Location:",  30, null, this, 1, 3);
		new Label("Rotation:",  30, null, this, 2, 3);
		new Label("Scale:"   ,  30, null, this, 3, 3);

		location_x = new NumberInput("X", 50, updateModel, this, 1, 3, NumberInput.ROUND_UP);
		location_y = new NumberInput("Y", 70, updateModel, this, 1, 3, NumberInput.ROUND_NONE);
		location_z = new NumberInput("Z", 90, updateModel, this, 1, 3, NumberInput.ROUND_DOWN);
		
		rotation_x = new NumberInput("X", 50,  updateModel, this, 2, 3 , NumberInput.ROUND_UP);
		rotation_y = new NumberInput("Y", 70,  updateModel, this, 2, 3 , NumberInput.ROUND_NONE);
		rotation_z = new NumberInput("Z", 90,  updateModel, this, 2, 3 , NumberInput.ROUND_DOWN);
		
		scale_x  =   new NumberInput("X", 50,  updateModel, this, 3, 3 , NumberInput.ROUND_UP);
		scale_y  =   new NumberInput("Y", 70,  updateModel, this, 3, 3 , NumberInput.ROUND_NONE);
		scale_z  =   new NumberInput("Z", 90,  updateModel, this, 3, 3 , NumberInput.ROUND_DOWN);
	}
	
	override public function update()
	{
		var transform:Transform = cast component;
		
		location_x.value = transform.x;
		location_y.value = transform.y;
		location_z.value = transform.z;
		
		rotation_x.value = transform.rotationX;
		rotation_y.value = transform.rotationY;
		rotation_z.value = transform.rotationZ;
		
		scale_x.value = transform.scaleX;
		scale_y.value = transform.scaleY;
		scale_z.value = transform.scaleZ;
	}
	
	override private function updateModel() 
	{
		var e:TransformEvent = new TransformEvent( TransformEvent.CHANGE );
		e.transform  = cast component;
		e.x          = location_x.value;
		e.y          = location_y.value;
		e.z          = location_z.value;
		e.rotationX  = rotation_x.value;
		e.rotationY  = rotation_y.value;
		e.rotationZ  = rotation_z.value;
		e.scaleX     = scale_x.value;
		e.scaleY     = scale_y.value;
		e.scaleZ     = scale_z.value;
		
		dispatchEvent( e );
	}
}