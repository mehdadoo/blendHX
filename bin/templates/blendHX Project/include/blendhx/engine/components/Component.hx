package blendhx.engine.components;

import blendhx.engine.events.Event;
import blendhx.engine.events.ComponentEvent;
import blendhx.engine.events.EventDispatcher;

class Component extends EventDispatcher implements IComponent
{
	public var transform:Transform;
	public var enabled:Bool = true;
	
	@:isVar public var name(get, set):String = "Component";
	@:isVar public var parent(get, set):IComposite;
	
	public function new( name:String = null )
	{
		this.name = name;
		super();
	}
	public function update():Void
	{
	}
	
	public function initialize():Void
	{
		var e:ComponentEvent = new ComponentEvent( ComponentEvent.INITIALIZED );
		dispatchEvent( e );
	}
	public function uninitialize():Void
	{
		var e:ComponentEvent = new ComponentEvent( ComponentEvent.UN_INITIALIZED );
		dispatchEvent( e );
	}
	
	public function clone():IComponent
	{ 
		return null;
		
	}
	
	override public function dispose()
	{
		super.dispose();
		
		if(parent!= null)
			parent.removeChild( this );
			
		name = null;
		parent = null;
		transform = null;
	}
	
	public function get_name():String
	{
		return name;
	}
	
	public function set_name(param:String):String
	{
		name = param;
		return param;
	}
	
	public function get_parent():IComposite
	{
		return parent;
	}
	
	//when component parent is changed, the transform component should as well be
	public function set_parent(value:IComposite):IComposite
	{
		parent = value;
		eventParent = value;
		
		if(parent != null)
		{
			transform = cast parent.getChild(Transform);
		}
		
		
		return parent;
	}
}