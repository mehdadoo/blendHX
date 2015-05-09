package blendhx.editor.mvc;

import blendhx.engine.Viewport;
import blendhx.engine.components.Camera;
import blendhx.engine.components.Transform;
import blendhx.engine.components.IComposite;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.assets.Mesh;

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
		var mouseEvent:MouseEvent = cast e;
		var viewport:Viewport = model.viewport;
		var isInViewport:Bool = model.viewport.contains(mouseEvent.stageX,mouseEvent.stageY);
		
		if( !isInViewport )
			return;
			
		var x:Int = Std.int( mouseEvent.stageX - viewport.x);
		var y:Int = Std.int( mouseEvent.stageY - viewport.y);
		
		var pickedEntity:IComposite = null;
		
		model.scene.removeChild( model.gridFloor);
		
		//trace(xUnit+", "+yUnit);
		bitmap = new BitmapData(Std.int(viewport.width), Std.int(viewport.height), false);
		render();
		
		var pickedColor:Int = bitmap.getPixel(x, y);
		for(i in 0...colors.length)
		{
			
			if( pickedColor == colors[i])
				pickedEntity =  model.scene.meshRenderers[i].parent;
		}
		
		bitmap.dispose();
		model.scene.addChild( model.gridFloor);
		
		if(pickedEntity!= null)
		{
			var e:HierarchyEvent = new HierarchyEvent(HierarchyEvent.SELECT);
			e.entity = pickedEntity;
			flash.Lib.current.stage.dispatchEvent(e);
		}
	}
	
	private function render()
	{
		var context3D:Context3D = model.scene.assets.context3D;
		
		if (context3D == null) return;
		if (context3D.profile == null)return;

		context3D.clear(0.22, 0.22, 0.22, 1.0);
		
		colors = [];
		
    	var transform:Transform;
    	var mesh:Mesh;
		var meshRenderers:Array<MeshRenderer> = model.scene.meshRenderers;
    	var camera:Camera = model.scene.cameras[0];
		
		if (camera == null)
			return;
		
    	for (meshRenderer in meshRenderers) 
		{
    		transform = meshRenderer.transform;
    		mesh = meshRenderer.mesh;
		
			//if there are no valid mesh in the meshRenderer, or disabled meshRenderer skip this meshRenderer
    		if (mesh == null) continue;
			
			shader.color = Color.random();
			colors.push(shader.color);
			
    		shader.updateMatrix(transform.getMatrix(), camera.getViewProjection());
    		shader.bind(context3D, mesh.vertexBuffer);
			
			
			//try drawing the mesh using the original shader of the meshRenderer
    		try 
			{
    			context3D.drawTriangles(mesh.indexBuffer);
    		} 
			//in case there is a problem with the shader, redraw it with the fallback shader
			catch(e:Dynamic) 
			{
				trace( e.message, 0xcc1111 );
    		};
			
			shader.unbind(context3D);
    		
    	};
		context3D.drawToBitmapData( bitmap );
    	//context3D.present();
    
	}
}