package blendhx.engine.events;

class EventDispatcher implements IEventDispatcher
{
	private var listeners:Map<String, Event->Void >;
	
	//parent used for bubbling the event up the tree
	private var eventParent:IEventDispatcher;
	
	public function new()
	{
		listeners  =  new Map();
	}
	public function dispatchEvent( event:Event ):Void
	{
		if( event.target == null)
			event.target = this;
		if( listeners != null && listeners.exists( event.type ) )
		{
			var callBackFunction:Event->Void = listeners.get( event.type );
			callBackFunction( event );
			event.dispose();
		}
			
		//bubble up, call parent to dispatch event
		else if( eventParent != null )
			eventParent.dispatchEvent( event );
	}
	
	public function addEventListener( type:String, listener:Event->Void ):Void
	{
		listeners.set(type, listener);
	}
	
	public function removeEventListener( type:String ):Void
	{
		listeners.remove( type );
	}
	
	public function dispose()
	{
		listeners = null;
		eventParent = null;
	}
}