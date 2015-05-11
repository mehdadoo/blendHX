package blendhx.engine;

import blendhx.engine.events.EntityEvent;
import blendhx.engine.events.Event;
import blendhx.engine.events.ComponentEvent;
import blendhx.engine.events.ScriptEvent;
import blendhx.engine.systems.RenderingSystem;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.components.Camera;
import blendhx.engine.components.Lamp;
import blendhx.engine.components.IComponent;
import blendhx.engine.components.IComposite;
import blendhx.engine.components.Entity;
import blendhx.engine.components.Script;
import blendhx.engine.assets.*;


import flash.geom.Rectangle;

//contains the scene graph hierarchy of the entity/components and also the asset manager
//document how and where and why is this class used elsewhere
class Scene extends Entity
{
	@:isVar public var entities(get, set):IComposite;
	
	//quick access to some components of the entities
	public var meshRenderers:Array<MeshRenderer> = new Array<MeshRenderer>();
	public var cameras:Array<Camera> = new Array<Camera>();
	public var lamps:Array<Lamp> = new Array<Lamp>();
	public var assets:Assets;

	//the entities and the camera events should be listened to
	public function new() 
	{
		super( "MainScene" );
		
		addEventListener( ComponentEvent.INITIALIZED     , onComponentInitialized);
		addEventListener( ComponentEvent.UN_INITIALIZED  , onComponentUnInitialized);
		
		entities = new Entity("Scene");
		assets = new Assets();
	}

	//dispose the scene and the assets completely from memory
	override public function dispose():Void
	{
		assets.dispose();
		entities.dispose();
		entities = null;
		assets = null;
		meshRenderers = null;
		cameras = null;

		super.dispose();
	}
	
	//initialize the entities and listen for it's events
	override public function initialize():Void
	{
		addEventListener( ComponentEvent.INITIALIZED     , onComponentInitialized);
		addEventListener( ComponentEvent.UN_INITIALIZED  , onComponentUnInitialized);
		
		entities.initialize();
	}
	
	public function get_entities() { return entities; }
	
	//dispose the existing entities, if any
	public function set_entities(value)
	{
		if(entities != null)
		{
			removeChild(entities);
			
			if(value == null)
				entities.dispose();

			entities = null;
			meshRenderers = [];
			cameras = [];
		}
		
		if(value == null)
			return null;
		
		entities = value;
		addChild( entities );
		
		return entities;
	}
	//resize all the scene cameras
	public function resize( rect:Rectangle ):Void
	{
		for (camera in cameras) 
			camera.resize( rect );
	}
	//if the component is meshRenderer or a camera, add it to it's corresponding list
	private function onComponentInitialized( event:Event ):Void
	{
		
		var isMeshRenderer:Bool = untyped __is__(event.target, MeshRenderer);
		var isCamera:Bool = untyped __is__(event.target, Camera);
		var isLamp:Bool = untyped __is__(event.target, Lamp);
		
		if(isMeshRenderer)
			registerMeshRenderer( cast event.target );
		else if( isCamera )
			registerCamera( cast event.target );
		else if( isLamp )
			registerLamp( cast event.target );
	}
	
	//if the component is meshRenderer or a camera, remove it from it's corresponding list
	private function onComponentUnInitialized( event:Event ):Void
	{
		
		var isMeshRenderer:Bool = untyped __is__(event.target, MeshRenderer);
		var isCamera:Bool = untyped __is__(event.target, Camera);
		var isLamp:Bool = untyped __is__(event.target, Lamp);

		if(isMeshRenderer)
			unregisterMeshRenderer( cast event.target );
		else if( isCamera )
			unregisterCamera( cast event.target );
		else if( isLamp )
			unregisterLamp( cast event.target );
	}
	
	private function registerMeshRenderer(meshRenderer:MeshRenderer)
    {
		//if the meshRenderer already exists, do not re register it, else add it to the mesh renderers array
    	for (m in meshRenderers) 
			if (m == meshRenderer)
				return;
		meshRenderers.push(meshRenderer);
		
    }

    private function unregisterMeshRenderer(meshRenderer:MeshRenderer)
    {
    	for (m in meshRenderers)
			if (m == meshRenderer) 
				meshRenderers.remove(m);
				
    }
	
	private function registerCamera(camera:Camera)
	{
		//if the camera already exists, do not re register it
    	for (c in cameras) 
			if (c.name == camera.name)
				return;
		
		//the editor camera if available, should always be the first on the list
		if(camera.name == "EditorCamera")
			cameras.unshift( camera );
		else
			cameras.push( camera );
		
    }

    private function unregisterCamera(camera:Camera)
    {
    	for (c in cameras)
			if (c == camera) 
				cameras.remove(c);
    }
	
	private function registerLamp(lamp:Lamp)
    {
		//if the lamp already exists, do not re register it, else add it to the mesh renderers array
    	for (m in lamps) 
			if (m == lamp)
				return;
		lamps.push(lamp);
		
    }

    private function unregisterLamp(lamp:Lamp)
    {
    	for (m in lamps)
			if (m == lamp) 
				lamps.remove(m);
				
    }
	
}