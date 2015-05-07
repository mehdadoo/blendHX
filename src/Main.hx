package;

import blendhx.engine.Utils;
import blendhx.engine.Scene;
import blendhx.engine.Viewport;
import blendhx.engine.events.Event;
import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Scripts;
import blendhx.engine.loaders.ILoader;
import blendhx.engine.loaders.ObjectLoader;
import blendhx.engine.systems.IRenderingSystem;
import blendhx.engine.systems.RenderingSystem;

import flash.display.StageAlign;
import flash.display.Stage;
import flash.display.StageScaleMode;

//to avoid conflicts with blendhx.events.Event, is not imported here but used inline
//import flash.events.Event;

class Main
{
    var stage   		:Stage;
    var scene   		:Scene;
	var viewport		:Viewport;
	var renderingSystem :IRenderingSystem;
	var assets  		:Assets;
	
	var casheDirectory:String = "cashe";
	
	#if editor
	var editor:blendhx.editor.mvc.MVCEditor;
	#end
	
    public static function main()
    {
    	new Main();
    }

    public function new():Void
    {
		scene    = new Scene();
		viewport = new Viewport();
		Utils.registerClassAliases();
		
    	initStage();
		initEditor();
		initRenderingSystem();
		startLoop(null);
		loadScene();
		
	}
	
	private function initStage():Void
    {
    	stage = flash.Lib.current.stage;
    	stage.scaleMode = StageScaleMode.NO_SCALE;
    	stage.align = StageAlign.TOP_LEFT;
    	stage.addEventListener(flash.events.Event.RESIZE, onStageResize);
    }
	
	private function initEditor():Void
	{
		#if editor
		editor = new blendhx.editor.mvc.MVCEditor(scene, viewport);

		casheDirectory = editor.get_casheDirectory();
		stage.addChild( editor );
		#end
	}
	function initRenderingSystem():Void
    {
		renderingSystem = new RenderingSystem( scene, viewport );
    	renderingSystem.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
    	renderingSystem.initialize();
    }
	
	function loadScene():Void
    {
		var sceneLoader:ILoader = new ObjectLoader("data.bin", casheDirectory);
		sceneLoader.addEventListener(Event.COMPLETE, loadSceneComplete);
		sceneLoader.addEventListener(Event.ERROR,    loadSceneError);
		sceneLoader.load();
	}
	function loadSceneError(e:Event):Void
    {
		var sceneLoader:ILoader = cast e.target;
		sceneLoader.dispose();
		
		loadScripts();
	}
	function loadSceneComplete(e:Event):Void
    {
		stopLoop( null );
		
		var sceneLoader:ILoader = cast e.target;
		
		var oldScene = scene;
		
		scene = sceneLoader.data;
		renderingSystem.scene = scene;
		scene.assets.context3D = renderingSystem.context3D;
		scene.initialize();
		
		#if editor
		editor.scene = scene;
		#end
		
		sceneLoader.dispose();
		oldScene.dispose();
		
		
		
		
		loadScripts();
	}
	
	private function loadScripts():Void
	{
		scene.assets.scripts = new Scripts();
		scene.assets.scripts.folder = casheDirectory;
		scene.assets.scripts.addEventListener(Event.COMPLETE, onScriptsLoad);
		scene.assets.scripts.addEventListener(Event.ERROR,    onScriptsLoad);
		scene.assets.scripts.load();
	}
	
	function onScriptsLoad(_):Void
    {
		scene.assets.scripts.removeEventListener(Event.COMPLETE);
		scene.assets.scripts.removeEventListener(Event.ERROR);
		
		scene.assets.addEventListener( Event.UN_INITIALIZED, stopLoop);
		scene.assets.addEventListener( Event.INITIALIZED,    startLoop);
		scene.assets.initialize();
		
		onStageResize(null);
	}
	
	
    function onContext3DCreate(_):Void
    {
		//trace( "onContext3DCreate");
		scene.assets.uninitialize();
		scene.assets.context3D = renderingSystem.context3D;
		scene.assets.initialize();
		onStageResize(null);
    }
	
	function startLoop(_):Void
	{
		stage.addEventListener(flash.events.Event.ENTER_FRAME, loop);	
	}
	function stopLoop(_):Void
	{
		
		stage.removeEventListener(flash.events.Event.ENTER_FRAME, loop);	
	}
	

    function onStageResize(_)
    {
		viewport.height = stage.stageHeight;
		viewport.width  = stage.stageWidth;
		
		#if editor
		editor.resize();
		#end
		
		scene.resize( viewport );
		
		
		if(renderingSystem != null)
			renderingSystem.resize();
    }

    function loop(_):Void
    {
		#if editor
		editor.update();
		#else
		scene.update();
		#end
    	renderingSystem.update();	
    }
}
