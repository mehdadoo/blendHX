package blendhx.engine.components;

import blendhx.engine.assets.Assets;
import blendhx.engine.assets.Material;
import blendhx.engine.assets.Mesh;

class MeshRenderer extends Component
{
	public var material:Material = null;
	public var mesh:Mesh = null;
	
	public function new()
	{
		super( "MeshRenderer" );
	}
	
	override public function clone():IComponent
	{
		var copy:MeshRenderer = new MeshRenderer();
		copy.enabled = enabled;
		copy.name = name;
		copy.material = material;
		copy.mesh = mesh;
		
		return copy;
	}
	
	override public function dispose()
	{
		super.dispose();
		
		material = null;
		mesh = null;
	}
}