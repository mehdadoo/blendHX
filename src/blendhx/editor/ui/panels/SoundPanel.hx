package blendhx.editor.ui.panels;

import blendhx.engine.components.Sound;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.controls.ObjectInput;
import blendhx.editor.ui.controls.Checkbox;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.SoundEvent;

class SoundPanel extends Panel
{
	private var sound_input:ObjectInput;
	private var playOnAwake_input:Checkbox;
	private var loop_input:Checkbox;
	private var is2D_input:Checkbox;
	private var volume_input:NumberInput;
	
	public function new() 
	{
		super("Sound", 200, true, true);
	}
	
	override private function initialize()
	{
		new Label( "Sound File" , 30, null, this, 1, 1);
		sound_input = new ObjectInput( "Sound"    ,50, updateModel, this, 1, 1, ControlBase.ROUND_BOTH,  ObjectType.SOUND );
		playOnAwake_input = new Checkbox("Play On Awake", 80,  updateModel, this, 1, 2);
		loop_input = new Checkbox("Loop", 80,  updateModel, this, 2, 2);
		is2D_input = new Checkbox("2D", 110,  updateModel, this, 1, 2);
		volume_input = new NumberInput("volume" , 110, updateModel, this, 2, 2, NumberInput.ROUND_BOTH);
		volume_input.max = 1.0;
		volume_input.step = 0.1;
	}
	
	override public function update()
	{
		var sound:Sound = cast component;
		
		if( sound.soundAsset != null)
			sound_input.value  = sound.soundAsset.sourceURL;
		else
			sound_input.value  = "";
			
		playOnAwake_input.value  = sound.playOnAwake;
		loop_input.value  = sound.loop;
		is2D_input.value  = sound.is2D;
		volume_input.value  = sound.volume;
	}
	
	override private function updateModel() 
	{
		var e:SoundEvent = new SoundEvent( SoundEvent.CHANGE );
		e.sound = cast component;
		e.sound_id = model.assets.getID( sound_input.value );
		e.playOnAwake = playOnAwake_input.value;
		e.loop = loop_input.value;
		e.is2D = is2D_input.value;
		e.volume = volume_input.value;
		
		dispatchEvent( e );
	}
}