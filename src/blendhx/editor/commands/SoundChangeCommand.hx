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
		
		sound.soundAsset = model.assets.get( Assets.SOUND, soundEvent.sound_id );
		
		super.execute();
	}
	
	override public function undo():Void
	{
		var soundEvent:SoundEvent = cast event;
		var sound:Sound = soundEvent.sound;
		
		sound.soundAsset = values.get("soundAsset");
				
		model.selectedEntity = model.selectedEntity;
		
		super.undo();
	}
	
	override public function redo():Void
	{
		execute();
		model.selectedEntity = model.selectedEntity;
	}
}