package blendhx.editor.ui.spaces;

import blendhx.editor.ui.headers.MenuHeader;
import blendhx.editor.mvc.IModel;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

class MenuSpace extends Space
{
	public function new( model:IModel ) 
	{
		super(null, 100);
		
		addHeader( new MenuHeader( model ) );
	}
}