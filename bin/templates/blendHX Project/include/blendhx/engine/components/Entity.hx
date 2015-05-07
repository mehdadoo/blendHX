package blendhx.engine.components;

import blendhx.engine.events.EntityEvent;
import blendhx.engine.events.ComponentEvent;

/*
Entitys contain components, a simple composition pattern
 */

class Entity extends Component implements IComposite
{
	public var children : Array<IComponent>;
	
	#if editor
	@:isVar public var collapseInHierarchy(get, set):Bool = false;
	
	public function get_collapseInHierarchy():Bool
	{
		return collapseInHierarchy;
	}
	
	public function set_collapseInHierarchy(param:Bool):Bool
	{
		collapseInHierarchy = param;
		dispatchEvent( new EntityEvent(EntityEvent.HIERARCHY_CHANGE) );
		return param;
	}
	#end
		
	//basic initializations
	public function new( name:String, createTransform:Bool = true) 
	{
		super( name );
		children = new Array<IComponent>();
		
		if(!createTransform)
			return;
		//there always need to be a transform component, because it's used so much
		var transform:Transform = new Transform();
		addChild( transform );
		this.transform = transform;
	}
	
	//upon destruction, call components to dispose
	override public function dispose()
	{
		super.dispose();
		
		if(children != null)
			for (child in children)
				child.dispose();
		
		children = null;
		
		
	}
	
	override public function clone():IComponent
	{
		var copy:Entity = new Entity( name, false);
		copy.enabled = enabled;
		
		for(child in children)
		{
			var component:IComponent = child.clone();
			copy.addChild( component );
			
			if(component.name == "Transform")
				copy.transform = cast component;
		}
		
		return copy;
	}
	
	override public function initialize():Void
	{
		for (child in children)
			child.initialize();
	}
	
	override public function uninitialize():Void
	{
		if( children != null)
		for (child in children)
			 child.uninitialize();
	}
	
	// calls child components update, if entity is enabled
	override public function update():Void
	{
		if (!enabled)
			return;
		
		for (child in children)
			if(child.enabled)
			 	child.update();
	}
	
	override public function set_name(param:String):String
	{
		name = param;

		dispatchEvent( new EntityEvent( EntityEvent.HIERARCHY_CHANGE ) );
		
		return param;
	}

	//why override that? because the transform component of and entity instance never changes, but the super class se_parent tries to change it.
	override public function set_parent(value)
	{
		super.parent = null;
		parent = value;
		eventParent  = value;
		return parent;
	}
	
	//add a child only if there isn't one already added with the same Type. There can't be two children of the same type in one Entity
	public function addChild(child:IComponent)
	{
		for (existingChild in children)
		{
			//if this object is not an entity, then we should check no to add the child if there's already a component of the same type added
			var isEntity:Bool = untyped __is__(child, Entity);
			if ( !isEntity )
			{
				if( child.name ==  existingChild.name )
				{
					trace("You can't add same component twice: "+this.name +","+ existingChild +", "+ child);
					child.dispose();
					return;
				}
			}
		
			//if child is already added
			if(existingChild == child)
			{
				trace( "Child is already added");
				return;
			}
		}
		
		children.push(child);
		child.parent = this;
		child.initialize();
	
		dispatchEvent( new EntityEvent(EntityEvent.HIERARCHY_CHANGE) );
	}

	//add a component to the children list, and also let component know that we are her parent
	public function removeChild(child:IComponent)
	{
		child.uninitialize();
		children.remove(child);
		child.parent = null;
		
		
		dispatchEvent( new EntityEvent(EntityEvent.HIERARCHY_CHANGE) );
	}
	
	//giving a reference to a child of a certain type
	public function getChild( componentType:Class<Dynamic> ):Dynamic
	{
		var componentTypeName:String = Std.string( componentType ).split(" ")[1];
		
		for (child in children)
		{
			var childClassName:String = Std.string( child ).split(" ")[1];
		
			if( childClassName ==  componentTypeName)
			{
				return child;
			}
		}

		return null;
	}
}