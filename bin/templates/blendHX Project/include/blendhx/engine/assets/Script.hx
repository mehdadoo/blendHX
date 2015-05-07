package blendhx.engine.assets;

import blendhx.engine.components.IComponent;
import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;

import flash.Vector;

import haxe.rtti.Meta;

class Script extends EventDispatcher implements IAsset
{
	public var sourceURL:String;
	public var id:UInt = 0;
	public var classDefinition:Class<Dynamic>;
	public var classFields:Array<String>;
	
	public function new():Void
	{
		classFields = [];
		super();
	}
	
	public function initialize( assets:Assets = null ):Void
	{
		classDefinition = assets.scripts.getClass( sourceURL );
		classFields = getClassFields();
		dispatchEvent( new Event(Event.INITIALIZED) );
	}
	
	public function uninitialize()
	{
		classDefinition = null;
		classFields = [];
	}
	
	override public function dispose():Void
	{
		uninitialize();
		super.dispose();
	}
	
	private function getClassFields( ):Array<String>
	{
		if( classDefinition == null)
			return [];
			
		var properties:Array<String> = [];
		
		var editor = Meta.getFields(classDefinition);
		var editorString = Std.string( editor );
		var editorObjects = editorString.split(", ");

		for (s in editorObjects)
		{
			s = StringTools.replace(s, "{ ", "");
			var fieldName = s.substring(0, s.indexOf(" : "));
			var fieldType = s.substring(s.lastIndexOf(" : [")+4, s.lastIndexOf("]"));
			properties.push(fieldName);
			properties.push(fieldType);
		}
		
		return properties;
	}
	
	public function createInstance( properties:Map<String, Dynamic> ):IComponent
	{
		if( classDefinition == null)
			return null;
			
		var component:IComponent = Type.createInstance(classDefinition, []);
		
		//set the component fields
		var length:Int = Std.int( classFields.length / 2 );
		for (i in 0...length)
		{
			var value = properties.get( classFields[(i*2)]);
			Reflect.setField(component, classFields[ i * 2 ], value);
		}
		
		component.name = sourceURL;
		return component;
	}
}