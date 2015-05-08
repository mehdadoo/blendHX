package blendhx.editor.ui.panels;

import blendhx.engine.components.Sound;

import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.NumberInput;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.controls.ObjectInput;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.SoundEvent;

class SoundPanel extends Panel
{
	var sound_input:ObjectInput;
	
	public function new() 
	{
		super("Sound", 200, true, true);
	}
	
	override private function initialize()
	{
		new Label( "Sound File" , 30, null, this, 1, 1);
		sound_input = new ObjectInput( "Sound"    ,50, updateModel, this, 1, 1, ControlBase.ROUND_BOTH,  ObjectType.SOUND );
	}
	
	override public function update()
	{
		var sound:Sound = cast component;
			
		sound_input.value  = (sound.soundAsset == null) ? "" : sound.soundAsset.sourceURL;
	}
	
	override private function updateModel() 
	{
		var e:SoundEvent = new SoundEvent( SoundEvent.CHANGE );
		e.sound = cast component;
		e.sound_id = model.assets.getID( sound_input.value );
		
		dispatchEvent( e );
	}
}