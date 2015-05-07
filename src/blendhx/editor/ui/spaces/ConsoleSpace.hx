package blendhx.editor.ui.spaces;

import blendhx.editor.ui.headers.ConsoleHeader;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

class ConsoleSpace extends Space
{
	private var log_textfield:TextField;
	
	public function new() 
	{
		super(null, 100, 0x454545);
		
		haxe.Log.trace = log;
		haxe.Log.clear = clear;
		
		createTextField();
		
		addHeader( new ConsoleHeader( null ) );
	}
	
	private function createTextField()
	{
		var t:TextField = new TextField();
		var tf:TextFormat = new TextFormat();

		tf.align   = TextFormatAlign.LEFT;
		t.autoSize = TextFieldAutoSize.LEFT;
		tf.font    = "Segoe UI";
		tf.color   = 0xa0a0a0;
		t.width    = 170;
		t.height   = _height;
		t.y        = 0;
		t.x        = 5;
		t.type     = TextFieldType.INPUT;
		t.selectable = true;
		t.defaultTextFormat = tf;
		t.text     = "Log console initialized. Use trace() to use.\n";
		
		addChild(t);
		log_textfield = t;
	}
	public function clear():Void
	{
		log_textfield.text = "";
	}
	
	public function log( v : Dynamic, ?inf : haxe.PosInfos ):Void
	{
		var oldtf:TextFormat = log_textfield.defaultTextFormat;
		
		if(inf.customParams != null)
		{
			var newtf:TextFormat = new TextFormat();
			newtf.font = "Segoe UI";
			newtf.color = inf.customParams[0];
			log_textfield.defaultTextFormat = newtf;
			log_textfield.appendText( Std.string (v) +'\n');
			
		}
		else
		{
			log_textfield.appendText( 
				inf.className+", line "+inf.lineNumber+": " +Std.string (v) +'\n');
		}
		
		log_textfield.defaultTextFormat = oldtf;
	}
	
	override public function resize()
	{
		log_textfield.y = header._height;
		super.resize();
	}
	
	override public function dispose()
	{
		super.dispose();
	}
}