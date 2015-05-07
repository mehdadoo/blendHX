package blendhx.engine.events;

class Event
{
	public static inline var COMPLETE:String = "event complete";
	public static inline var ERROR:String = "event error";
	public static inline var CONTEXT3D_CREATE:String = "event context3d created";
	public static inline var INITIALIZED:String = "initialized";
	public static inline var UN_INITIALIZED:String = "un_initialized";

	public var type:String;
	public var target:IEventDispatcher;

	public function new( type:String ):Void
	{
		this.type = type;
	}
	
	public function dispose()
	{
		target = null;
	}
}