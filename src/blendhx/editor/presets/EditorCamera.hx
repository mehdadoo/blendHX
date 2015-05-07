package blendhx.editor.presets;

import blendhx.engine.components.Entity;
import blendhx.engine.components.Camera;

class EditorCamera extends Entity
{
	public var camera:Camera;
	
	public function new()
	{
		super( "EditorCamera" );
		
		camera = new Camera("EditorCamera");
		addChild( camera );
		addChild( new EditorCameraController() );
	}
	override public function dispose()
	{
		super.dispose();
		camera = null;
	}
}