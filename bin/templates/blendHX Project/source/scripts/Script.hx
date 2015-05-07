package scripts;

import blendhx.engine.components.*;

class Script extends Component
{
	@editor("Float")
	public var speed:Float = 0.0;
	
	//constructor called at start up
	public function new()
	{
		super();
	}
	
	//calls every frame
	override public function update():Void
	{
		transform.rotationY += speed;
	}
	
	//called when the parent Entity is destroyed
	override public function dispose():Void
	{
		//base class dispose call once after your own clean up
		super.dispose();
	}
}