package blendhx.editor.commands;

import blendhx.engine.loaders.ILoader;
//import blendhx.engine.loaders.MeshLoader;
import blendhx.engine.assets.Mesh;

import blendhx.editor.data.ObjParser;
import blendhx.editor.helpers.Utils;
import blendhx.editor.helpers.Color;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.filesystem.*;
import flash.net.FileFilter;

class AssetsImportMeshCommand extends Command
{
	override public function execute():Void
	{
		var currentDirectory:File = model.currentAssetsDirectory;
		
 		var meshesFilter = new FileFilter("Mesh", "*.obj");
		
		var file:File = new File();
		file.addEventListener(Event.SELECT, importFile );
		file.addEventListener(Event.CANCEL, cancel     );
		file.browseForOpen("Import Mesh", [ meshesFilter]);	
	}
	
	private function cancel(e:Event)
	{
		dispose();
	}
	private function importFile(e:Event)
	{
		var file:File = e.target;
		
		var sourceFolderFile:File =  model.currentAssetsDirectory.resolvePath( file.name );
		
		if(sourceFolderFile.exists)
		{
			trace("A file with the same name already exists.", Color.RED);
			dispose();
			return;
		}
		
		file.copyTo( sourceFolderFile );
		
		var bytes:ByteArray = new ByteArray();
		
		var stream = new FileStream();
		stream.open(file, FileMode.READ);
		stream.readBytes( bytes);
		stream.close();
		
		var myObjMesh:ObjParser = new ObjParser(bytes, 1);
		
		var mesh:Mesh = new Mesh(myObjMesh.GetIndexData(), myObjMesh.GetVertexData(true, false, false) );
		
		//create the loader used by the assets library
		var sourceURL:String = Utils.getLocalURL(model.sourceDirectory, sourceFolderFile );
		var id:UInt = model.assets.getNewID();
		mesh.sourceURL = sourceURL;
		mesh.id = id;
		model.assets.meshes.push( mesh );
		mesh.initialize( model.assets );
		
		model.selectedFileItem = null;
		
		dispose();
	}
}