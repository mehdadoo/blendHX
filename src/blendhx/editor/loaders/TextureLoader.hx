package blendhx.editor.loaders;

import blendhx.engine.loaders.Loader;
import blendhx.engine.events.Event;

class TextureLoader extends Loader
{	
	override private function onComplete()
	{
		//can't call super, becuase it will erase the loaded bytes needed by the user
		//super.onComplete();
		cleanupUrlLoader();
		
		data = bytes;
		
		var event:Event = new Event( Event.COMPLETE ); 
		dispatchEvent( event );
	}
}