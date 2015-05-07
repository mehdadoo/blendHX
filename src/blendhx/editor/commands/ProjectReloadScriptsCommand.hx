package blendhx.editor.commands;

import blendhx.engine.loaders.Loader;
import blendhx.engine.events.Event;
import blendhx.engine.events.ProgressEvent;
import blendhx.editor.helpers.Color;
import blendhx.editor.events.ProgressEvent;

import flash.filesystem.File;
import flash.Vector;

class ProjectReloadScriptsCommand extends Command
{
	private var compileProcess:Process;
	
	override public function execute():Void
	{
		if(Process.getInstance().isRunning() )
		{
			return;
		}
		
		var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, 0, 1);
		e.isEndless = true;
		e.text = "Compiling scripts";
		model.dispatchEvent( e );
		
		compileProcess = Process.getInstance();
		compileProcess.addEventListener( flash.events.Event.COMPLETE  , onScriptsCompiled );
		compileProcess.addEventListener( flash.events.ErrorEvent.ERROR, onScriptsCompileError);
		
		compile();
	}
	
	public function compile():Void
	{
		var file:File = model.projectDirectory.resolvePath( "compile.cmd" );
		var args:Vector<String> = new Vector<String>();
		compileProcess.startProcess(args, file, model.projectDirectory);
	}
	private function onScriptsCompileError( e:flash.events.ErrorEvent )
	{
		trace(e.text, Color.ORANGE);
		dispose();
	}
	private function onScriptsCompiled( _ )
	{
		model.assets.scripts.addEventListener(Event.COMPLETE, onScriptsLoaded);
		model.assets.scripts.addEventListener(Event.ERROR, onScriptsLoadError);
		model.assets.scripts.load(); 
	}
	
	private function onScriptsLoadError( _ )
	{
		trace("Can't load scripts!", Color.RED);
		dispose();
	}
	
	private function onScriptsLoaded( _ )
	{
		model.assets.initialize();
		
		dispose();
	}
	
	
	
	override public function dispose()
	{
		model.dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, 1, 1 , ProgressEvent.SCRIPTS_COMPILED) );
		
		compileProcess.removeEventListener( flash.events.Event.COMPLETE  , onScriptsCompiled );
		compileProcess.removeEventListener( flash.events.ErrorEvent.ERROR, onScriptsCompileError);
		compileProcess.dispose();
		compileProcess = null;
		
		super.dispose();
	}
	
}