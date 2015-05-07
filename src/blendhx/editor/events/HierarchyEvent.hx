package blendhx.editor.events;

import blendhx.engine.components.IComposite;

class HierarchyEvent extends DisposableEvent
{
	public static inline var SELECT:String        = "entity select";
	public static inline var RIGHT_CLICK:String   = "entity right click";
	public static inline var NEW:String           = "entity new";
	public static inline var DELETE:String        = "entity delete";
	public static inline var REPARENT:String      = "entity reparent";
	public static inline var RENAME:String        = "entity rename";
	public static inline var RENAME_REQUEST:String= "entity rename request";
	//public static inline var REPLACE_COMPONENT:String= "entity replace component";
	
	public var entityName:String;
	public var entity:IComposite;
	
	//public var oldComponentClassName:String;
	//public var newComponentClassURL:String;
	
	override public function dispose():Void
	{
		entity = null;
		entityName = null;
		//newComponentClassURL = null;
		//oldComponentClassName = null;
	}
}
