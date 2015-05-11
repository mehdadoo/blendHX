package blendhx.engine.components;


class Lamp extends Component
{
	public var energy:Float = 1.0;
	public var shadow:Bool;
	
	public function new( name:String = "Lamp") 
	{
		super( name );
	}

	override public function clone():IComponent
	{
		var copy:Lamp = new Lamp();
		copy.enabled = enabled;
		copy.name = name;
		copy.energy = energy;
		copy.shadow = shadow;

		return copy;
	}
	
	
	override public function dispose()
	{
		super.dispose();
	}
}