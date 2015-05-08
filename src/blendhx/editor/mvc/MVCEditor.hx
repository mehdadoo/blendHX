package blendhx.editor.mvc;

import blendhx.engine.assets.Assets;
import blendhx.engine.Scene;
import blendhx.engine.Viewport;
import blendhx.engine.events.Event;

import blendhx.editor.ui.Progressbar;
import blendhx.editor.ui.UIComposite;
import blendhx.editor.mvc.*;
import blendhx.editor.events.*;

import flash.display.Stage;
import flash.filesystem.File;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class MVCEditor extends UIComposite
{
	private var model     :IModel;
	private var controller:IController;
	private	var view      :EditorView;
	private var renameView:UICompositeView;
	private var dragController:IController;
	private var shortcutController:IController;
	
	@:isVar public var scene(null, set):Scene;
	
	public function new(scene:Scene, viewport:Viewport) 
	{
		super();
		
		model      = new EditorModel( scene );
		controller = new EventCommandController( model );
		view       = new EditorView( model, viewport );
		
		renameView = new RenameView( model );
		dragController = new DragController( model );
		shortcutController = new ShortcutController( model );
		
		addUIComponent( view );
		addUIComponent( renameView );
		
		registerListeners();
		
		dispatchEvent( new ProjectEvent(ProjectEvent.REQUEST_LOAD_PROJECT));
		
		view.update();
		view.resize();	

	}
	
	public function set_scene(value:Scene):Scene
	{
		model.scene = value;
		return value;
	}
	
	private function registerListeners():Void
	{
		//model events
		model.addEventListener( ModelEvent.CHANGE, onModelChanged);
		model.addEventListener( ProgressEvent.PROGRESS, onAssetsProgress );
		model.addEventListener( ProjectEvent.RELOAD_SCRIPTS    ,handleEvents );
		
		//view events sent to the controller
		var stage:Stage = flash.Lib.current.stage;

		addEventListener(ProjectEvent.REQUEST_LOAD_PROJECT, handleEvents );
		
		stage.addEventListener(ProjectEvent.UNDO, handleEvents );
		stage.addEventListener(ProjectEvent.REDO, handleEvents );
		
		stage.addEventListener(AssetsEvent.CREATE_ACTIONSCRIPT,handleEvents );
		stage.addEventListener(AssetsEvent.CREATE_HAXE_FILE   ,handleEvents );
		stage.addEventListener(AssetsEvent.CREATE_NEW_FOLDER  ,handleEvents );
		stage.addEventListener(AssetsEvent.CREATE_MATERIAL    ,handleEvents );
		stage.addEventListener(AssetsEvent.CREATE_SHADER      ,handleEvents );
		stage.addEventListener(AssetsEvent.IMPORT_TEXTURE     ,handleEvents );
		stage.addEventListener(AssetsEvent.IMPORT_MESH        ,handleEvents );
		stage.addEventListener(AssetsEvent.IMPORT_SOUND       ,handleEvents );
		stage.addEventListener(AssetsEvent.SELECT             ,handleEvents );
		stage.addEventListener(AssetsEvent.RENAME             ,handleEvents );
		stage.addEventListener(AssetsEvent.DELETE             ,handleEvents );
		stage.addEventListener(AssetsEvent.OPEN               ,handleEvents );
		stage.addEventListener(ProjectEvent.RELOAD_SCRIPTS    ,handleEvents );
		stage.addEventListener(ProjectEvent.EXPORT_SWF        ,handleEvents );
		stage.addEventListener(ProjectEvent.EDIT_MODE         ,handleEvents );
		stage.addEventListener(ProjectEvent.PLAY_MODE         ,handleEvents );
		stage.addEventListener(ProjectEvent.OPEN              ,handleEvents );
		stage.addEventListener(ProjectEvent.SAVE              ,handleEvents );
		stage.addEventListener(ProjectEvent.NEW               ,handleEvents );
		stage.addEventListener(ProjectEvent.HELP              ,handleEvents );
		
		
		stage.addEventListener(HierarchyEvent.REPARENT ,handleEvents );
		stage.addEventListener(HierarchyEvent.SELECT   ,handleEvents );
		stage.addEventListener(HierarchyEvent.RENAME   ,handleEvents );
		stage.addEventListener(HierarchyEvent.DELETE   ,handleEvents );
		stage.addEventListener(HierarchyEvent.NEW      ,handleEvents );
		
		stage.addEventListener(ComponentEvent.REMOVE   ,handleEvents );
		stage.addEventListener(ComponentEvent.ENABLE   ,handleEvents );
		stage.addEventListener(ComponentEvent.NEW      ,handleEvents );
		
		stage.addEventListener(ScriptEvent.CHANGE       ,handleEvents );
		stage.addEventListener(MeshRendererEvent.CHANGE ,handleEvents );
		stage.addEventListener(TransformEvent.CHANGE    ,handleEvents );
		stage.addEventListener(SoundEvent.CHANGE        ,handleEvents );
		stage.addEventListener(MaterialEvent.CHANGE     ,handleEvents );
		stage.addEventListener(CameraEvent.CHANGE       ,handleEvents );
		
		stage.addEventListener(ControlBaseEvent.FOCUS     ,handleEvents );
		
		
		stage.addEventListener(HierarchyEvent.RENAME_REQUEST, handleRenameEvents);
		stage.addEventListener(AssetsEvent.RENAME_REQUEST   , handleRenameEvents);
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, handleDragEvents);
		stage.addEventListener(MouseEvent.MOUSE_OUT , handleDragEvents);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN , handleKeyboardEvents);
		
	}
	
	private function handleKeyboardEvents(e:flash.events.Event)
	{
		shortcutController.handleEvent( e );
	}
	
	private function handleRenameEvents(e:flash.events.Event)
	{
		renameView.update();
	}
	
	private function handleDragEvents(e:MouseEvent)
	{
		dragController.handleEvent( e );
	}
	
	private function handleEvents(e:flash.events.Event)
	{
		controller.handleEvent( e );
	}
	
	private function onAssetsProgress(e:ProgressEvent)
	{
		var progressBar = Progressbar.getInstance();
		progressBar.progress = e.progress;
		progressBar.total    = e.total;
		progressBar.show(e.text, e.isEndless);
	}

	private function onModelChanged(_)
	{
		view.update();
		view.resize();
	}	
	public function update()
	{
		if(model.playMode)
			model.scene.update();
	}	
	//is this a good way to load a project?!
	public function get_casheDirectory():String
	{
		return model.casheDirectory.url;
	}
}