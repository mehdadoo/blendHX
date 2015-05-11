package blendhx.engine.assets;

import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;
import blendhx.engine.presets.DefaultShader;
import blendhx.editor.data.AS3DefinitionHelper;

import hxsl.Shader;

import flash.system.ApplicationDomain;

class Material extends EventDispatcher implements IAsset
{
	public var sourceURL:String;
	public var id:UInt = 0;
	
	public var shader:Shader;
	public var shaderURL:String = "shaders/DefaultShader.hx";
	
	//populated according to Shader properties, used by the MaterialPanel in editor
	public var properties:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	public function new():Void
	{
		super();
	}
	
	// in material properties panel, values are set into the shader like this
	/*public function setProperty(propertyName:String, propertyValue:Dynamic):Void
	{
		properties.set(propertyName, propertyValue);
	}*/
	
	public function initialize( assets:Assets = null ):Void
	{
		if (properties == null)
			properties = new Map<String, Dynamic>();
			
		shader = assets.getShader( shaderURL );
		updateShaderProperties( assets );
		dispatchEvent( new Event(Event.INITIALIZED) );
	}
	private function updateShaderProperties(assets:Assets):Void
	{
		var values:Array<Dynamic> = [];
		var value:Dynamic;
		var length:Int = Std.int( shader.editorProperties.length / 2 );
		
		for (i in 0...length)
		{
			switch ( shader.editorProperties[ (i*2) +1] )
			{
				case "Texture":
					var texture_id:UInt = assets.getID( properties.get(shader.editorProperties[i*2] ));
					var texture:Texture = cast assets.get( Assets.TEXTURE, texture_id);
					
					if( texture != null )
						value = texture.texture;
					else
						value = null;
				case "Color":
					value = properties.get( shader.editorProperties[i*2] );
				case "Float":
					value = properties.get( shader.editorProperties[i*2] );
				default:
					value = null;
			}
			
			values.push(value);
		}
		
		shader.updateProperties(values);
		values = null;
	}
	
	public function uninitialize():Void
	{	
		shader = null;
	}
	
	override public function dispose():Void
	{
		uninitialize();
		properties = null;
		super.dispose();
	}
}