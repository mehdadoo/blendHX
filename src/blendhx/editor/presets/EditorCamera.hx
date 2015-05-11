package blendhx.editor.presets;

import blendhx.engine.components.Entity;
import blendhx.engine.components.Camera;

class EditorCamera extends Entity
{
	public var camera:Camera;
	public var controller:EditorCameraController;
	
	public function new()
	{
		super( "EditorCamera" );
		
		camera = new Camera("EditorCamera");
		controller = new EditorCameraController();
		
		addChild( camera );
		addChild( controller );
	}
	override public function dispose()
	{
		super.dispose();
		camera = null;
		controller = null;
	}
}