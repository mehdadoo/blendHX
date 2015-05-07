package blendhx.editor.ui;

import blendhx.editor.ui.ExtendedTextField;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextFormatAlign;
import flash.events.Event;

import flash.events.TimerEvent;
import flash.utils.Timer;

class Progressbar extends UIComponent
{
	private static var instance:Progressbar;
	
	public  var percent:Float = 0;
	public  var total:Int = 0;
	public  var progress:Int = 0;
	
	private var hideTimer:Timer;
	private var text:String="";
	private var isEndLess:Bool;
	private var graphic:Sprite;
	private var label:ExtendedTextField;
	private var progressGraphic:Sprite;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new Progressbar();
      	else
          return instance;
  	}	
	
	public function new() 
	{
		super();
		
		_width = 0;
		
		hideTimer = new Timer(1000, 1);
		hideTimer.addEventListener(TimerEvent.TIMER, onHideTimer);
		
		createGraphics();
	}
	
	private function createGraphics() 
	{
		label = new ExtendedTextField(TextFormatAlign.LEFT, "Loading...");
		label.width = 100;
		graphic = new Sprite();
		var borderImage:BitmapData = new blendhx.editor.ui.embeds.Images.Progressbar(0, 0);
		graphic.addChild( new Bitmap( borderImage ) ).y = 18;
		graphic.addChild( label );
		
		progressGraphic = new Sprite();
		graphic.addChild(progressGraphic);
	}
	
	public function hide() 
	{
		label.text = "Completed";
		isEndLess = false;
		if(!hideTimer.running)
		{
			hideTimer.reset();
			hideTimer.start();
		}
	}
	
	private function onHideTimer(_)
	{
		hideTimer.stop();
		
		if( contains(graphic) )
		{
			_width = 0;
			removeChild(graphic);
			removeEventListener( Event.ENTER_FRAME, update);
			container.resize();
		}
	}
	
	public function update( _ ) 
	{
		var g:Graphics = progressGraphic.graphics;
		g.clear();
		g.beginFill(0x444444);
		
		if(isEndLess)
		{
			percent += 1;
			if(percent>200)
				percent =0;
			
			var start:Float = 1;
			var end:Float = 100;
			if (percent < 100)
			{
				start = 1;
				end = percent;
			}
				
			else
			{
				start = 100 ;
				end = percent - 200;
			}
				
			g.drawRect(start, 19, end, 2);
		}
		else
		{
			percent = (progress+1) * 100 / (total+1);
			g.drawRect(1, 19, percent, 2);
		}
			
		g.endFill();
		
		if( progress == total )
			hide();
	}
	
	public function show(text:String, isEndLess:Bool = false) 
	{
		if( contains(graphic) )
			return;
		
		
		_width = 105;
		
		percent = 0;
		this.isEndLess = isEndLess;
		if( !hasEventListener(Event.ENTER_FRAME) )
			addEventListener( Event.ENTER_FRAME, update);
		
		label.text = text;
		this.text = text;
		addChild(graphic);
		container.resize();
	}
}