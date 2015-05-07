package blendhx.engine.components;

import com.adobe.utils.PerspectiveMatrix3D;

import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;

class Camera extends Component
{
	private var projection:PerspectiveMatrix3D;
	public var fov:Float = 60;
	public var near:Float = 0.1;
	public var far:Float = 1000;
	
	private var aspectRatio:Float =  1;
	private var viewProjection:Matrix3D;
	
	public function new( name:String = "Camera") 
	{
		super( name );
		
		viewProjection = new Matrix3D();
		projection = new PerspectiveMatrix3D();
		
		resize();
	}

	override public function clone():IComponent
	{
		var copy:Camera = new Camera();
		copy.enabled = enabled;
		copy.name = name;
		copy.projection = new PerspectiveMatrix3D( projection.rawData );
		copy.aspectRatio = aspectRatio;
		copy.fov = fov;
		copy.near = near;
		copy.far = far;
		copy.viewProjection = viewProjection.clone();
		
		return copy;
	}
	
	
	override public function dispose()
	{
		super.dispose();
		projection = null;
		viewProjection = null;
	}
	
	public function resize( rect:Rectangle = null )
	{
		if( rect!=null && rect.height > 0 && rect.width > 0)
			aspectRatio =  rect.width / rect.height;
		
		projection.perspectiveFieldOfViewLH(fov*Math.PI/180, aspectRatio, near, far);
	}
	
	public function getViewProjection():Matrix3D
	{
		viewProjection.identity();
		
		viewProjection.append(transform.getMatrix() );
		viewProjection.append(projection);
		return viewProjection;
	}
}