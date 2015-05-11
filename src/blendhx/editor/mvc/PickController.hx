package blendhx.editor.mvc;

import blendhx.engine.Viewport;
import blendhx.engine.components.Camera;
import blendhx.engine.components.Transform;
import blendhx.engine.components.IComposite;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.assets.Mesh;
import blendhx.engine.assets.Assets;

import blendhx.editor.events.HierarchyEvent;
import blendhx.editor.helpers.Color;
import blendhx.editor.presets.ColorShader;

import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.display3D.Context3D;

class PickController implements IController
{
	public var model:IModel;
	private var shader:ColorShader;
	private var colors:Array<Int> = [];
	private var entities:Array<IComposite> = [];
	private var bitmap:BitmapData = null;
	
	public function new(model:IModel):Void
	{
		this.model = model;
		shader = new ColorShader();
		shader.create(ApplicationDomain.currentDomain);
		shader.color = 10;
	}

	public function handleEvent(e:Event):Void
	{
		if( model.playMode )
			return;
			
		var mouseEvent:MouseEvent = cast e;
		var viewport:Viewport = model.viewport;
		var isInViewport:Bool = model.viewport.contains(mouseEvent.stageX,mouseEvent.stageY);
		
		if( !isInViewport )
			return;
			
		var x:Int = Std.int( mouseEvent.stageX - viewport.x);
		var y:Int = Std.int( mouseEvent.stageY - viewport.y);
		
		var pickedEntity:IComposite = null;
		
		model.scene.removeChild( model.gridFloor);
		model.scene.removeChild( model.transformGizmo);
		
		//trace(xUnit+", "+yUnit);
		bitmap = new BitmapData(Std.int(viewport.width), Std.int(viewport.height), false);
		drawSceneToBitmapdata();
		
		var pickedColor:Int = bitmap.getPixel(x, y);
		for(i in 0...entities.length)
		{
			if( pickedColor == colors[i])
				pickedEntity =  entities[i];
		}
		
		bitmap.dispose();
		model.scene.addChild( model.gridFloor);
		model.scene.addChild( model.transformGizmo);
		
		if(pickedEntity!= null)
		{
			var e:HierarchyEvent = new HierarchyEvent(HierarchyEvent.SELECT);
			e.entity = pickedEntity;
			flash.Lib.current.stage.dispatchEvent(e);
		}
	}
	
	private function drawSceneToBitmapdata()
	{
		var context3D:Context3D = model.scene.assets.context3D;
		
		if (context3D == null) return;
		if (context3D.profile == null)return;

		context3D.clear(0.22, 0.22, 0.22, 1.0);
		
		colors = [];
		entities = [];
		
    	var transform:Transform;
    	var mesh:Mesh;
		var meshRenderers:Array<MeshRenderer> = model.scene.meshRenderers;
    	var camera:Camera = model.scene.cameras[0];
		var cameraMesh:Mesh = model.scene.assets.get(Assets.MESH, model.scene.assets.getID("editor/cameraPick.obj") );
		var lampMesh:Mesh = model.scene.assets.get(Assets.MESH, model.scene.assets.getID("editor/lampPick.obj") );
		
		if (camera == null)
			return;
		
    	for (meshRenderer in meshRenderers) 
			render( context3D, meshRenderer.mesh, meshRenderer.transform, camera);
		
		for(i in 1...model.scene.cameras.length)
			render( context3D, cameraMesh, model.scene.cameras[i].transform, camera);
		
		for(lamp in model.scene.lamps)
			render( context3D, lampMesh, lamp.transform, camera);
    		

		context3D.drawToBitmapData( bitmap );
    	//context3D.present();
	}
	
	private function render(context3D:Context3D, mesh:Mesh, transform:Transform, camera:Camera)
	{
		if (mesh == null) return;
		
		shader.color = Color.random();
		colors.push(shader.color);
		entities.push( transform.parent );
		
		shader.updateMatrix(transform.getMatrix(), camera.getViewProjection());
		shader.bind(context3D, mesh.vertexBuffer);
		
		try 
		{
			context3D.drawTriangles(mesh.indexBuffer);
		}
		catch(e:Dynamic) 
		{
			trace( e.message, 0xcc1111 );
		}
		
		shader.unbind(context3D);
	}
	
}