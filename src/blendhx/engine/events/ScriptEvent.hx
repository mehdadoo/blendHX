package blendhx.engine.events;

import blendhx.engine.components.IComposite;

class ScriptEvent extends Event
{
	public static inline var REQUEST_COMPONENT:String = "script request component";
	
	public var sourceURL:String;

	public function new(type:String, sourceURL:String)
	{
		super(type);

		this.sourceURL = sourceURL;
	}
}