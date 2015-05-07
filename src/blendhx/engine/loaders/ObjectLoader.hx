package blendhx.engine.loaders;

import blendhx.engine.components.Entity;
import blendhx.engine.components.Camera;
import blendhx.engine.components.MeshRenderer;

class ObjectLoader extends Loader
{	
	override private function onComplete()
	{
		data = bytes.readObject();
		super.onComplete();
	}
}