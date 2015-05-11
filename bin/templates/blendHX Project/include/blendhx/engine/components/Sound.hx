package blendhx.engine.components;

import blendhx.engine.assets.Assets;

import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
	


class Sound extends Component
{
	private var sound:flash.media.Sound;
	private var soundChannel:SoundChannel;
	private var soundTransform:SoundTransform;
	private var pausePosition:Float = 0;
	private var soundStatus:UInt;
	
	public var soundAsset:blendhx.engine.assets.Sound;
	
	public var playOnAwake:Bool = true;
	public var loop:Bool = false;
	public var is2D:Bool = true;
	@:isVar public var volume(get, set):Float = 1.0;

	
	public function new()
	{
		super( "Sound" );
		soundStatus = SoundStatus.Stop;
	}
	
	override public function dispose()
	{
		stop();
		sound = null;
		soundAsset = null;
		soundChannel = null;
		
		super.dispose();
	}
	
	override public function update():Void
	{
		if(sound != null)
			return;
			
		if(soundAsset == null)
			return;
			
		
		if( soundChannel != null)
			stop();
			
		sound = new flash.media.Sound();
		soundAsset.bytes.position = 0;
		sound.loadCompressedDataFromByteArray( soundAsset.bytes, soundAsset.bytes.length );
		soundTransform = new SoundTransform(volume, 0.0);
		
		if( playOnAwake )
			play();
	}
	
	override public function initialize()
	{
		if( soundStatus == SoundStatus.Play )
			play();
		super.initialize();
	}
	
	override public function uninitialize()
	{
		if( soundStatus == SoundStatus.Play )
		{
			pause();
			soundStatus = SoundStatus.Play;
		}
		super.uninitialize();
	}
	
	override public function clone():IComponent
	{
		var copy:Sound = new Sound();
		copy.enabled = enabled;
		copy.name = name;
		copy.soundAsset = soundAsset;
		copy.playOnAwake = playOnAwake;
		copy.loop = loop;
		copy.is2D = is2D;
		copy.volume = volume;
		
		return copy;
	}
	
	public function play():Void
	{
		if(soundChannel !=null )
			return;
		
		soundStatus = SoundStatus.Play;
		
		soundChannel = sound.play( pausePosition );
		soundChannel.soundTransform = soundTransform;
		soundChannel.addEventListener( Event.SOUND_COMPLETE, soundCompleteHandler );
	}
	public function pause():Void
	{
		if( soundChannel == null)
			return;
		
		soundStatus = SoundStatus.Pause;
		
		pausePosition = soundChannel.position;
		soundChannel.stop();
		soundChannel.removeEventListener( Event.SOUND_COMPLETE, soundCompleteHandler );
		soundChannel = null;
	}
	public function stop():Void
	{
		if( soundChannel == null)
			return;
		
		soundStatus = SoundStatus.Stop;
		
		pausePosition = 0;
		soundChannel.stop();
		soundChannel.removeEventListener( Event.SOUND_COMPLETE, soundCompleteHandler );
		soundChannel = null;
	}
	
	private function soundCompleteHandler(_):Void 
	{
		stop();
		
		if( loop )
			play();
	}
	
	public function get_volume():Float
	{
		return volume;
	}
	
	public function set_volume(param:Float):Float
	{
		volume = param;

		if( soundTransform != null)
		{
			soundTransform.volume = volume;
			soundChannel.soundTransform = soundTransform;
		}
		
		return param;
	}
	
}