package blendhx.editor.ui.panels;

import blendhx.engine.components.Lamp;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.Checkbox;
import blendhx.editor.events.LampEvent;

class LampPanel extends Panel
{
	private var shadow_input:Checkbox;
	private var energy_input:NumberInput;
	
	public function new() 
	{
		super("Lamp", 200, true, true);
	}
	
	override private function initialize()
	{
		energy_input = new NumberInput("Energy" , 30, updateModel, this, 1, 2, NumberInput.ROUND_BOTH);
		energy_input.max = 1.0;
		energy_input.step = 0.1;
		
		shadow_input = new Checkbox("Shadow", 30, updateModel, this, 2, 2);
	}
	
	override public function update()
	{
		var lamp:Lamp = cast component;
		
		energy_input.value  = lamp.energy;
		shadow_input.value  = lamp.shadow;
	}
	
	override private function updateModel() 
	{
		var e:LampEvent = new LampEvent( LampEvent.CHANGE );
		e.lamp = cast component;
		e.energy = energy_input.value;
		e.shadow = shadow_input.value;

		dispatchEvent( e );
	}
}