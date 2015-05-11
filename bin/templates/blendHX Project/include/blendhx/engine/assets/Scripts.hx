package blendhx.engine.assets;

import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;
import blendhx.engine.loaders.ILoader;
import blendhx.engine.loaders.SWFLoader;
import blendhx.editor.data.AS3DefinitionHelper;

import blendhx.engine.components.Component;
import blendhx.engine.components.Script;
import blendhx.engine.presets.DefaultShader;

import hxsl.Shader;

import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.utils.ByteArray;
//import flash.events.Event;
import flash.events.IOErrorEvent;

class Scripts extends EventDispatcher
{
	public  var file:String = "scripts.swf";
	public  var folder:String;
	private var loader:SWFLoader;
	private var domain:ApplicationDomain;
	
	public function new()
	{
		super();
	}
	
	override public function dispose():Void
	{
		domain = null;
		super.dispose();
	}
	
	public function load()
	{
		loader = new SWFLoader(file, folder);
		domain = loader.domain;
		
		loader.addEventListener(Event.COMPLETE, onComplete);
		loader.addEventListener(Event.ERROR,    onComplete);
		loader.load();
	}
	
	private function onComplete( e:Event )
	{
		dispatchEvent( e );
		loader.dispose();
		
		if(e.type == Event.ERROR)
			trace( e.type );
	}
	public function getClass( sourceURL:String ):Class<Dynamic>
	{	
		
		var className:String = Utils.GetClassNameFromURL( sourceURL );
		//Haxe throws un-catchable error here if it cant find the definition
		//domain.getDefinition( className ); 
		var componentClass:Class<Dynamic> = AS3DefinitionHelper.getClassByName(domain, className);
		
		
		if(componentClass == null)
			trace("Script definition not found. Consider re compiling\n"+className, 0xee5511);
		else if(Type.getSuperClass(componentClass) != Component)
			trace("Selected script is not extending blendhx.engine.components.Component", 0xee5511);
		
		return componentClass;
	}
	
	public function getComponent( sourceURL:String ):Component
	{
		var className:String = Utils.GetClassNameFromURL( sourceURL );
		var componentClass:Class<Dynamic> = getClass( sourceURL ); 
		
		if(componentClass==null)
			return null;
			
		var component:Component =  Type.createInstance(componentClass, []);//cast(AS3DefinitionHelper.Instantiate(domain, className, Component), Component); 
		component.name = className;
		
		return component;
	}
	
	public function getShader( sourceURL:String ):Shader
	{
		var className:String = Utils.GetClassNameFromURL( sourceURL );
		var shader:Shader;
		
		shader =  cast(AS3DefinitionHelper.Instantiate(domain, className, Shader), Shader);
		
		if(shader == null)
		{
			shader = new DefaultShader();
			shader.create( ApplicationDomain.currentDomain );
			
		}
		else
		{
			shader.create( domain );
		}
		shader.initProperties();
		
		return shader;
	}
}