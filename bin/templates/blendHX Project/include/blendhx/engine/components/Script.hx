package blendhx.engine.components;

import blendhx.engine.assets.IAsset;
import blendhx.engine.events.ScriptEvent;

class Script extends Component
{
	public var properties:Map<String, Dynamic>;
	public var asset:IAsset;
	
	public function new ( asset:IAsset = null):Void
	{
		if(asset!=null)
			super( asset.sourceURL );
		else
			super();
			
		this.asset = asset;
		
		properties = new Map<String, Dynamic>();
	}
	
	override public function update()
	{
		//remove this component and replace it with an actual script component
		var scriptAsset:blendhx.engine.assets.Script = cast asset;
		var component:IComponent = scriptAsset.createInstance( properties );
		var entity = parent;
		entity.removeChild( this );
		
		if(component!=null)
			entity.addChild( component );
			
		this.dispose();
	}
	
	override public function clone():IComponent
	{
		var copy:Script = new Script( asset );
		copy.properties = properties;
		
		return copy;
	}
	
	override public function dispose()
	{
		properties = null;
		asset = null;
		super.dispose();
	}
	
}