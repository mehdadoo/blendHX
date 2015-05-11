package blendhx.editor.presets;

import blendhx.engine.components.Component;
import blendhx.engine.components.Transform;

import flash.geom.Vector3D;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.events.MouseEvent;

class EditorCameraController extends Component
{
	public var distance:Float = 7;
	public var target:Vector3D = new Vector3D(0, 0, 0);
	private var easeDiffVector:Vector3D = new Vector3D(0, 0, 0);
	private var angleX:Float = 30;
	private var angleY:Float = -30;
	private var startX:Float=0;
	private var startY:Float=0;
	private var isMiddleDown:Bool;
	private var animationTimer:Timer = new Timer(0.02, 10); 
	
	
	override public function initialize()
	{
		
		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		flash.Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, oMiddleDown);
		flash.Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, oMiddleUp);
		flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		animationTimer.addEventListener(TimerEvent.TIMER, animationStep);
		
		updateMatrix();
		
		super.initialize();
	}
	
	override public function uninitialize():Void
	{
		flash.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		flash.Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, oMiddleDown);
		flash.Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, oMiddleUp);
		flash.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		animationTimer.removeEventListener(TimerEvent.TIMER, animationStep);
		
		super.uninitialize();
	}
	
	public  function focus( targetTransform:Transform):Void
	{
		easeDiffVector.x = -targetTransform.x - target.x;
		easeDiffVector.y = -targetTransform.y - target.y;
		easeDiffVector.z = -targetTransform.z - target.z;
		
		animationTimer.start();	
	}

	
	private function animationStep(e:TimerEvent)
	{
		target.x += easeDiffVector.x / animationTimer.repeatCount;
		target.y += easeDiffVector.y / animationTimer.repeatCount;
		target.z += easeDiffVector.z / animationTimer.repeatCount;
		updateMatrix();
		
		if(animationTimer.currentCount == animationTimer.repeatCount)
		{
			animationTimer.stop();
			animationTimer.reset();
		}
	}
	
	private function onMouseWheel(e:MouseEvent):Void
	{
		distance -= e.delta ;
		
		if(distance > 20)
			distance = 20;
		else if(distance < 2)
			distance = 2;
		updateMatrix();
	}
	private function oMiddleDown(e:MouseEvent):Void
	{
		isMiddleDown = true;
		startX = e.stageX;
		startY = e.stageY;
	}
	private function oMiddleUp(e:MouseEvent):Void
	{
		isMiddleDown = false;
	}
	
	private function onMouseMove(e:MouseEvent):Void
	{
		if( !isMiddleDown)
			return;

		
		angleX -= ( e.stageX - startX)/3;
		angleY -= ( e.stageY - startY)/3;
		
		updateMatrix();
		
		startX = e.stageX;
		startY = e.stageY;
	}
	
	
	public function updateMatrix():Void
	{
		transform.matrix.identity();
		transform.matrix.appendTranslation(target.x, target.y, target.z);
		transform.matrix.appendRotation(angleX, Vector3D.Y_AXIS);
		transform.matrix.appendRotation(angleY, Vector3D.X_AXIS);
		transform.matrix.appendTranslation(0, 0, distance);
	}
}