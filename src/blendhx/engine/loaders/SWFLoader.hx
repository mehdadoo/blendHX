package blendhx.engine.loaders;

import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.Vector;

class SWFLoader extends blendhx.engine.loaders.Loader
{
	public var domain:ApplicationDomain;
	
	public function new(file:String,  casheDirectory:String = "") 
	{
		super(file, casheDirectory);
		domain = new ApplicationDomain(ApplicationDomain.currentDomain);
	}
	
	
	override private function onComplete()
	{
		var loader:flash.display.Loader = new flash.display.Loader();
		var loaderContext : LoaderContext = new LoaderContext();
		
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, scriptsLoaded);
		loaderContext.applicationDomain = domain;
		loaderContext.allowCodeImport = true;
		loader.loadBytes(bytes, loaderContext);
	}

	private function scriptsLoaded( e:Event )
	{
		var loader:flash.display.Loader = cast(e.target, LoaderInfo).loader;
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, scriptsLoaded);
		loader.unload();
		super.onComplete();
	}
	
	

	override public function dispose():Void
	{
		domain = null;
		super.dispose();
	}

}