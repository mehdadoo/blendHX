package blendhx.engine.assets;

import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;

import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.Context3D;
import flash.Vector;
import flash.utils.ByteArray;

class Mesh extends EventDispatcher implements IAsset
{
	public var sourceURL:String;
	public var id:UInt = 0;
	
	private var meshIndexData:Vector<UInt>;
	private var meshVertexData:Vector<Float>;
	public  var numVertexAttributes:UInt = 5;
	public  var triangles:UInt = 0;
	public  var vertexBuffer:VertexBuffer3D;
	public  var indexBuffer:IndexBuffer3D;
	
	public function new(meshIndexData:Vector<UInt>=null, meshVertexData:Vector<Float>=null):Void
	{
		if(meshIndexData == null)
			return;
		
		this.meshIndexData = meshIndexData;
		this.meshVertexData= meshVertexData;
		
		triangles = Std.int(meshIndexData.length / 3);
		
		//if there aren't any triangles, mesh data is empty, should be investigated
		if( triangles == 0 )
			trace("Mesh data is empty. Please ask the developer to investigate");
		
		super();
	}
	
	
	public function initialize( assets:Assets = null ):Void
	{
		//asset should be explicitly uninitialized
		if(vertexBuffer==null)
		{
			var context3D = assets.context3D;
			vertexBuffer = context3D.createVertexBuffer( Std.int(meshVertexData.length/numVertexAttributes) , numVertexAttributes); 
			vertexBuffer.uploadFromVector(meshVertexData, 0, Std.int(meshVertexData.length/numVertexAttributes));

			indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
			indexBuffer.uploadFromVector(meshIndexData, 0, meshIndexData.length);
		}
		
		dispatchEvent( new Event(Event.INITIALIZED) );
		
		
	}
	
	public function uninitialize()
	{
		if(vertexBuffer == null)
			return;
		
		vertexBuffer.dispose();
		indexBuffer.dispose();
		
		vertexBuffer = null;
		indexBuffer = null;
	}
	
	override public function dispose():Void
	{
		uninitialize();
		meshIndexData = null;
		meshVertexData = null;
		super.dispose();
	}
}