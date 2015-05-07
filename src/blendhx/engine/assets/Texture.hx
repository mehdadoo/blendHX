package blendhx.engine.assets;

import blendhx.engine.events.EventDispatcher;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3D;
import flash.utils.ByteArray;

class Texture extends EventDispatcher implements IAsset
{
	public var sourceURL:String;
	public var id:UInt = 0;
	
	private var width  :UInt;
	private var height :UInt;
	public var bytes:ByteArray;
	public  var texture:flash.display3D.textures.Texture;
	
	public function new(width:UInt, height:UInt ):Void
	{
		this.width = width;
		this.height = height;
		super();
	}
	
	public function initialize( assests:Assets = null ):Void
	{
		//asset should be explicitly uninitialized
		if(texture != null)
		{
			dispatchEvent( new blendhx.engine.events.Event(blendhx.engine.events.Event.INITIALIZED) );
			return;
		}
		
		texture = assests.context3D.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
		texture.addEventListener(Event.TEXTURE_READY, onTextureReady);
		texture.addEventListener(ErrorEvent.ERROR, onTextureUploadError);
		texture.uploadCompressedTextureFromByteArray(bytes, 0, true);
	}	
	public function uninitialize():Void
	{
		if(texture != null)
			texture.dispose();
		texture = null;
	}
	
	override public function dispose():Void
	{
		uninitialize();
		bytes.clear();
		bytes = null;
		
		super.dispose();
	}
	
	private function onTextureUploadError(e:ErrorEvent):Void
	{
		trace(id + ": " + e.text);
		texture.removeEventListener(Event.TEXTURE_READY, onTextureReady);
		texture.removeEventListener(ErrorEvent.ERROR, onTextureUploadError);
		
		dispatchEvent( new blendhx.engine.events.Event(blendhx.engine.events.Event.INITIALIZED) );
	}
	
	//now that it has finished uploading, call the callback function if any
	private function onTextureReady(_):Void
	{
		texture.removeEventListener(Event.TEXTURE_READY, onTextureReady);
		texture.removeEventListener(ErrorEvent.ERROR, onTextureUploadError);
		
		dispatchEvent( new blendhx.engine.events.Event(blendhx.engine.events.Event.INITIALIZED) );
	}
}
	

