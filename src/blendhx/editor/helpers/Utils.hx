package blendhx.editor.helpers;

import flash.filesystem.File;

class Utils
{
	public static inline function getLocalURL(releativeTo:File, file:File):String
	{
		return StringTools.urlDecode(file.url.substring(releativeTo.url.length+1));
	}
	
	
	public static function GetClassNameFromURL(url:String):String
    {
    	var className:String = StringTools.replace(url, "/", ".");
    	className = className.substring(0, className.length - 3);
    	return className;
    }
	
	public static function GetTitle(str:String):String
    {
		//var firstChar:String = str.substring( 0, 1);
		//var title:String = firstChar.toUpperCase() + str.substring( 1 );
    	return str;
    }
	
	public static function PrintFloat(f:Float, decimals:Int):String
	{
		var no = Std.string(f).split('.');
		if(no.length>=2)
		{
			var out = no[0] + "." +no[1].substr( 0, decimals );
			return out;
		}
		else
		{
			if(Std.string(f) == "NaN")
				return "0";
			return Std.string(f);
		}
	}
}