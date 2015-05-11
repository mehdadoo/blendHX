package blendhx.engine.systems;

import blendhx.engine.components.Entity;
import blendhx.engine.components.Camera;
import blendhx.engine.components.Transform;
import blendhx.engine.components.MeshRenderer;
import blendhx.engine.assets.Mesh;
import blendhx.engine.presets.DefaultShader;
import blendhx.engine.Scene;
import blendhx.engine.Viewport;
import blendhx.engine.events.EventDispatcher;
import blendhx.engine.events.Event;

import hxsl.Shader;

import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display.Stage3D;
import flash.display.Stage;
import flash.events.ErrorEvent;
import flash.errors.Error;
import flash.Lib;
import flash.system.ApplicationDomain;

class RenderingSystem extends EventDispatcher implements IRenderingSystem
{
    public  var context3D:Context3D;
	public  var viewport :Viewport;
	public  var scene    :Scene;
    private var fallbackShader:DefaultShader;
	private var fallbackCamera:Camera;
    private var shaderError:String;
	
	public function new(scene:Scene, viewport:Viewport)
	{
		super();
		this.viewport = viewport;
		this.scene = scene;
	}
	
	private function initShaderFallback()
    {
    	fallbackShader = new DefaultShader();
		fallbackShader.color = 0xcccccc;
    	fallbackShader.create(ApplicationDomain.currentDomain);
    }
	private function initCameraFallback()
    {
    	var cameraEntity:Entity = new Entity("fallbackCamera");
		fallbackCamera = new Camera();
		cameraEntity.addChild(fallbackCamera);
    }

    public function initialize()
    {
		initShaderFallback();
		initCameraFallback();
		
    	Lib.current.stage.stage3Ds[0].addEventListener(flash.events.Event.CONTEXT3D_CREATE, initContext3D);
    	Lib.current.stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, context3DError);
    	Lib.current.stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE );
    }

    private function context3DError(e:ErrorEvent)
    {
    	trace(e.text);
    }

    private function initContext3D(_)
    {		
    	context3D = Lib.current.stage.stage3Ds[0].context3D;
    	context3D.enableErrorChecking = true;
    	context3D.configureBackBuffer(640, 480, 0, true);
    	context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
    	//context3D.setCulling(Context3DTriangleFace.BACK);
    	//context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
    	context3D.addEventListener(ErrorEvent.ERROR, context3DError);
		
		trace(context3D.driverInfo, 0xa6a6a6);
		
    	dispatchEvent( new Event(  Event.CONTEXT3D_CREATE ) );
    }


    public function update()
    {
		//stop rendering frame if there are no scene or rendering context initialized, or context has been already disposed by OS
    	if (context3D == null) return;
		if (scene     == null) return;
		if (context3D.profile == null)return;

		context3D.clear(0.22, 0.22, 0.22, 1.0);
		
    	var transform:Transform;
    	var mesh:Mesh;
    	var shader:Shader;
		var meshRenderers:Array<MeshRenderer> = scene.meshRenderers;
    	var camera:Camera = scene.cameras[0];
		var lamp:Transform = null;
		
		if(scene.lamps[0] != null)
			lamp = scene.lamps[0].transform;
			
		if (camera == null)
			camera = fallbackCamera;
		
    	for (meshRenderer in meshRenderers) 
		{
			
    		transform = meshRenderer.transform;
    		mesh = meshRenderer.mesh;
		
			//if there are no valid mesh in the meshRenderer, or disabled meshRenderer skip this meshRenderer
    		if (mesh == null) continue;
		
		
		
			//in case meshRenderer has no matrial, draw it with the fallback shader, else use the original shader
    		if (meshRenderer.material == null)
			{
				shader = fallbackShader;
				if(lamp!=null)
					fallbackShader.lamp = new flash.geom.Vector3D(lamp.x, lamp.y, lamp.z);
			}
			else
				shader = meshRenderer.material.shader;		
			
			
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
    			if (shaderError != e.message)
				{
					trace( e.message, 0xcc1111 );
					shaderError = e.message;
				}
    		};
			shader.unbind(context3D);
    		
    	};
	
    	context3D.present();
    }
	
    
	//resize stage3D
	public function resize()
	{
		Lib.current.stage.stage3Ds[0].x = viewport.x;
		Lib.current.stage.stage3Ds[0].y = viewport.y;
		
		var width:UInt = Std.int( viewport.width );
		var height:UInt = Std.int( viewport.height );
		
		if( context3D!=null )
			context3D.configureBackBuffer( width, height, 4, true);
	}
}