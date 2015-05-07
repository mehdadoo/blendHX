package blendhx.editor.commands;

import blendhx.engine.loaders.Loader;
//import blendhx.engine.loaders.MaterialLoader;

import blendhx.engine.assets.*;

import blendhx.editor.helpers.Utils;

import flash.utils.ByteArray;
import flash.filesystem.*;

class AssetsNewMaterialCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		
		//create new material
		var id:UInt =  model.assets.getNewID();
		var newMaterial:File =  currentDirectory.resolvePath("material"+ id +".mat");
		var sourceURL:String = Utils.getLocalURL( model.sourceDirectory, newMaterial );
		
		var material:Material = new Material();
		material.shaderURL = "shaders/DefaultShader.hx";
		material.sourceURL = sourceURL;
		material.id = id;
		material.initialize( model.assets);
		model.assets.materials.push( material );
		
		//dummy file write------------------
		var bytes:ByteArray = new ByteArray();
		bytes.writeInt( id );
		bytes.position = 0;
		
		var stream = new FileStream();
		stream.open(newMaterial, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		bytes.clear();
		//----------------------------
		
		
		
		model.selectedFileItem = null;
		
		super.execute();
	}
	
	private function writeDummyFile( material:Material ):Void
	{
		
	}
}