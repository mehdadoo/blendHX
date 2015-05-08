package blendhx.engine.assets;

import blendhx.engine.components.Component;
import blendhx.engine.events.Event;
import blendhx.engine.events.ProgressEvent;
import blendhx.engine.events.EventDispatcher;
import blendhx.engine.presets.GridFloorMesh;

import hxsl.Shader;

import flash.display3D.Context3D;
import flash.system.ApplicationDomain;

class Assets extends EventDispatcher implements IAsset
{
	public var sourceURL:String = "";
	public var id:UInt = 1;
	
	public inline static var TEXTURE  :UInt = 0;
	public inline static var MATERIAL :UInt = 1;
	public inline static var MESH     :UInt = 2;
	public inline static var COMPONENT:UInt = 3;
	public inline static var SOUND    :UInt = 4;
	
	//repository of GPU uploaded assets
	public var textures  :Array<IAsset> = new Array<IAsset>();
	public var materials :Array<IAsset> = new Array<IAsset>();
	public var meshes    :Array<IAsset> = new Array<IAsset>();
	public var components:Array<IAsset> = new Array<IAsset>();
	public var sounds    :Array<IAsset> = new Array<IAsset>();
	
	private var assetsArray:Array<Array<IAsset>>;
	
	public var scripts:Scripts;
	public var context3D:Context3D;

	public function new():Void
	{	
		assetsArray = [textures, materials, meshes, components, sounds];
		scripts = new Scripts();
		meshes.push( new GridFloorMesh() );
		
		super();
	}
	
	override public function dispose():Void
	{
		for(assetArray in assetsArray)
		{
			for (asset in assetArray)
			{
				asset.dispose();
				asset = null;
			}
			assetArray = null;
		}
		
		scripts.dispose();
		
		assetsArray = null;
		context3D = null;
		scripts = null;
	
		super.dispose();
	}
	
	private var totalAssets:UInt = 0;
	private var readyAssets:UInt = 0;
	
	public function initialize( assests:Assets = null ):Void
	{			
		totalAssets = 0;
		readyAssets = 0;
		
		for(assetArray in assetsArray)
		{
			for (asset in assetArray)
			{
				totalAssets ++;
				asset.addEventListener( Event.INITIALIZED, onAssetInitialize);
				asset.initialize( this );
				//trace("id: " + asset.id + " - " + asset.sourceURL, blendhx.editor.helpers.Color.GRAY);
			}
		}
	}
	
	private function onAssetInitialize( _ ):Void
	{
		//a change in an asset like material should not dispatch any events
		if( readyAssets == totalAssets)
			return;
			
		readyAssets++;
		
		var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, readyAssets, totalAssets);
		dispatchEvent( e );
		
		//all the assets have been initialized
		if( readyAssets == totalAssets)
			dispatchEvent( new Event(Event.INITIALIZED) );
	}
	
	public function uninitialize():Void
	{	
		for(assetArray in assetsArray)
			for (asset in assetArray)
				asset.uninitialize();
		
		context3D = null;
		
		dispatchEvent( new Event(Event.UN_INITIALIZED) );
	}
	
	public function get( type:UInt, id:UInt ):Dynamic
	{
		//select the target assets-array of the same type
		var assetArray:Array<IAsset> = assetsArray[type];
		
		//find and return the asset with the same sourceURL
		for (asset in assetArray)
			if (asset.id == id)
				return asset;
		
		//asset not found
		return null;
	}
	
	public function moveAsset(sourceURL:String, destinationURL:String):Void
	{
		for(assetArray in assetsArray)
			for (asset in assetArray)
				if (asset.sourceURL == sourceURL)
					asset.sourceURL = destinationURL;
	}
	
	// remove asset object from Asset
	public function removeAsset(sourceURL:String):Void
	{
		for(assetArray in assetsArray)
		{
			for (asset in assetArray)
			{
				if (asset.sourceURL == sourceURL)
				{
					assetArray.remove( asset );
					asset.dispose();
					asset = null;
				}
			}
		}
	}
	
	public function getID( sourceURL:String ):UInt
	{
		if(sourceURL == null)
			return 0;
			
		for(assetArray in assetsArray)
			for (asset in assetArray)
				if (asset.sourceURL == sourceURL)
					return asset.id;
		
		trace("Asset " +sourceURL +" not found.", 0xff6600, false);
		
		return 0;
	}
	public function getSourceURL( id:UInt ):String
	{
		for(assetArray in assetsArray)
			for (asset in assetArray)
				if (asset.id == id)
					return asset.sourceURL;
		return null;
	}
	
	public function getNewID():UInt
	{
		return ++id;
	}
	
	public function getComponent( sourceURL:String ):Component
	{
		return scripts.getComponent( sourceURL );
	}
	
	public function getShader( sourceURL:String ):Shader
	{
		return scripts.getShader( sourceURL );
	}
}