package blendhx.editor.ui;

import flash.text.Font;
import blendhx.editor.ui.embeds.EditorFont;
import blendhx.core.*;
import flash.text.TextFormatAlign;
import flash.text.GridFitType;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;


class ExtendedTextField extends TextField
{
	
	@:isVar public var align(get, set):TextFormatAlign;
	
	public function new(_align:TextFormatAlign, _text:String="",_x:Float=0, _y:Float=0, _selectable:Bool=false)
	{
		super();

		Font.registerFont(EditorFont);

		var textFormat:TextFormat = new TextFormat();
		textFormat.font = new EditorFont().fontName;
		textFormat.align = _align;
		
		//embedFonts = true;
		cacheAsBitmap = true;
		multiline = false;
		defaultTextFormat = textFormat;

		selectable = _selectable;
		text = _text;
		x = _x;
		y = _y;
	}
	
	public function get_align():TextFormatAlign{return align;}
	public function set_align(param:TextFormatAlign):TextFormatAlign
	{
		align = param;
		
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = new EditorFont().fontName;
		textFormat.align = param;
		
		setTextFormat(textFormat, 0, text.length);
		defaultTextFormat = textFormat;
		
		return param;
	}
}
