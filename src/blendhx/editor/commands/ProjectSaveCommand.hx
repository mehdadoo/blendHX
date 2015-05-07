package blendhx.editor.commands;


import blendhx.engine.Scene;
import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Scripts;

import blendhx.editor.helpers.Color;

import flash.utils.ByteArray;
import flash.filesystem.*;
import flash.display3D.Context3D;

class ProjectSaveCommand extends Command
{
	override public function execute():Void
	{
		if(model.playMode)
		{
			super.execute();
			trace("You can't save scene while in play mode.", Color.ORANGE);
			return;
		}
		
		var scene:Scene = model.scene;
		
		//remove the camera, and change it with a play time camera
		scene.removeChild( model.editorCamera);
		scene.removeChild( model.gridFloor);
		scene.entities.initialize();
		
		var assets:Assets = model.assets;
		var context3D:Context3D = assets.context3D;
		var scripts:Scripts = assets.scripts;
		
		//unload the GPU buffers and classes from the saving bytes
		assets.uninitialize();
		assets.scripts = null;
		
		
		//save the reload friendly scene into bytes
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(scene);
		bytes.position = 0;
		
		var saveFile:File = model.casheDirectory.resolvePath("data.bin");
		
		var stream = new FileStream();
		stream.open(saveFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		bytes.clear();
		
		//load the assets again
		assets.scripts = scripts;
		assets.context3D = context3D;
		assets.initialize();
		scene.addChild( model.editorCamera);
		scene.addChild( model.gridFloor);
		
		super.execute();
	}
}