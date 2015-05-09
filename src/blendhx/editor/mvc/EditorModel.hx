package blendhx.editor.mvc;

import blendhx.engine.Scene;
import blendhx.engine.Viewport;
import blendhx.engine.components.Camera;
import blendhx.engine.components.IComposite;
import blendhx.engine.events.EntityEvent;
import blendhx.engine.events.ProgressEvent;
import blendhx.engine.assets.Assets;

import blendhx.editor.presets.EditorCamera;
import blendhx.editor.presets.GridFloor;
import blendhx.editor.helpers.IDragable;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.events.ProgressEvent;
import blendhx.editor.events.ModelEvent;
import blendhx.editor.ui.FileItem;
import blendhx.editor.ui.HierarchyItem;
import blendhx.editor.ui.controls.ControlBase;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;

class EditorModel extends flash.events.EventDispatcher implements IModel
{
	
	@:isVar public var entities(get, set):IComposite;
	@:isVar public var assets (get, set):Assets;
	@:isVar public var scene  (get, set):Scene;
	public var viewport :Viewport;
	
	public var playMode:Bool;
	public var savedEntities:IComposite;
	public var editModeSelectedEntity:IComposite;
	public var editorCamera:EditorCamera;
	public var gridFloor:IComposite;
	
	@:isVar public var selectedEntity        (get, set):IComposite;
	@:isVar public var selectedFileItem      (get, set):FileItem;
	@:isVar public var currentAssetsDirectory(get, set):File;
	@:isVar public var projectDirectory      (get, set):File;
	
	public var selectedHierarchyItem : HierarchyItem;
	public var sourceDirectory   :File;
	public var casheDirectory    :File;
	public var lastSelectedObject:UInt; 
	public var version           :String = "blendhx v0.509";
	public var focusedControlBase:ControlBase;
	public var dragItem          :IDragable;
	
	public function new(scene:Scene):Void
	{
		this.editorCamera = new EditorCamera();
		this.gridFloor = new GridFloor( scene.assets );
		this.scene = scene;
		
		super();
	}
	public function get_entities():IComposite
	{
		return scene.entities;
	}
	public function set_entities(param:IComposite):IComposite
	{
		return param;
	}
	
	public function get_assets():Assets
	{
		return scene.assets;
	}
	public function set_assets(param:Assets):Assets
	{
		return param;
	}
	
	public function get_scene():Scene
	{
		return scene;
	}
	public function set_scene(param:Scene):Scene
	{
		if( scene != null)
		{
			scene.removeChild(editorCamera);
			scene.removeChild(gridFloor);
			scene.assets.removeEventListener(ProgressEvent.PROGRESS);
			scene.removeEventListener(EntityEvent.HIERARCHY_CHANGE);
		}
		
		scene = param;
		
		
		scene.assets.addEventListener(ProgressEvent.PROGRESS, onAssetsProgress );
		scene.addEventListener(EntityEvent.HIERARCHY_CHANGE, onSceneHierarchyChanged);
		scene.addChild(editorCamera);
		gridFloor.dispose();
		gridFloor = new GridFloor( scene.assets );
		scene.addChild(gridFloor);
		
		selectedEntity = param.entities;
		
		return param;
	}
	
	
	private function onAssetsProgress(ee:blendhx.engine.events.Event)
	{
		var pe:blendhx.engine.events.ProgressEvent = cast ee;
		
		var e:ProgressEvent = new ProgressEvent(pe.type, pe.progress, pe.total);
		e.text = "Loading Assets";
		dispatchEvent( e );
	}
	
	private function onSceneHierarchyChanged(_)
	{
		//Select scene if nothing else is selected
		if(selectedEntity == null || selectedEntity.parent == null)
			selectedEntity = entities;

		dispatchEvent( new ModelEvent(ModelEvent.CHANGE));
	}
	
	public function get_selectedEntity():IComposite
	{
		return selectedEntity;
	}
	public function set_selectedEntity(param:IComposite):IComposite
	{
		selectedEntity = param;
		lastSelectedObject = ObjectType.ENTITY;
		
		dispatchEvent( new ModelEvent(ModelEvent.CHANGE));
		
		return param;
	}
	
	public function get_selectedFileItem():FileItem
	{
		return selectedFileItem;
	}
	public function set_selectedFileItem(param:FileItem):FileItem
	{
		
		selectedFileItem = param;
		
		if (param == null)
			lastSelectedObject = ObjectType.ENTITY;
		else
			lastSelectedObject = ObjectType.OTHERS;
		
		dispatchEvent( new ModelEvent(ModelEvent.CHANGE));
		
		return param;
	}
	
	public function get_currentAssetsDirectory():File
	{
		return currentAssetsDirectory;
	}
	public function set_currentAssetsDirectory(param:File):File
	{
		currentAssetsDirectory = param;
		lastSelectedObject = ObjectType.FOLDER;
		
		dispatchEvent( new ModelEvent(ModelEvent.CHANGE));
		
		return param;
	}
	
	public function get_projectDirectory():File
	{
		return projectDirectory;
	}
	public function set_projectDirectory(param:File):File
	{
		if(projectDirectory!= null)
			return null;
		
		projectDirectory = param;
		sourceDirectory  = projectDirectory.resolvePath("source");
		casheDirectory   = projectDirectory.resolvePath("cashe");
		currentAssetsDirectory = sourceDirectory;
		
		return param;
	}
}