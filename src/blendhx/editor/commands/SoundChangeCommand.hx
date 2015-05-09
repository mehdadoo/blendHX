package blendhx.editor.commands;

import blendhx.engine.assets.Assets;
import blendhx.engine.components.Sound;

import blendhx.editor.events.SoundEvent;

class SoundChangeCommand extends CommandWithUndo
{
	override public function execute():Void
	{
		var soundEvent:SoundEvent = cast event;
		var sound:Sound = soundEvent.sound;
		
		values.set("soundAsset", sound.soundAsset);
		values.set("playOnAwake", sound.playOnAwake);
		values.set("loop", sound.loop);
		values.set("is2D", sound.is2D);
		values.set("volume", sound.volume);
		
		sound.soundAsset  = model.assets.get( Assets.SOUND, soundEvent.sound_id );
		sound.playOnAwake = soundEvent.playOnAwake;
		sound.loop        = soundEvent.loop;
		sound.is2D        = soundEvent.is2D;
		sound.volume      = soundEvent.volume;
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var soundEvent:SoundEvent = cast event;
		var sound:Sound = soundEvent.sound;
		
		sound.soundAsset = values.get("soundAsset");
		sound.playOnAwake = values.get("playOnAwake");
		sound.loop = values.get("loop");
		sound.is2D = values.get("is2D");
		sound.volume = values.get("volume");
				
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
}