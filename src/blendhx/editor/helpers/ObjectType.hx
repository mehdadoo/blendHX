package blendhx.editor.helpers;

class ObjectType
{
	public static var BLENDER:UInt = 0;
	public static var OTHERS:UInt = 1;
	public static var TEXTURE:UInt = 2;
	public static var SCRIPT:UInt = 3;
	public static var AUDIO:UInt = 4;
	public static var FOLDER:UInt = 5;
	public static var BACK:UInt = 6;
	public static var AS:UInt = 7;
	public static var MATERIAL:UInt = 8;
	public static var MESH:UInt = 9;
	public static var ENTITY:UInt = 10;
	
	public static function GetType(extension:String):UInt
	{
		switch (extension)
		{
			case "":
				return FOLDER;
			case "png":
				return TEXTURE;
			case "atf":
				return TEXTURE;
			case "blend":
				return BLENDER;
			case "back":
				return BACK;
			case "obj":
				return MESH;
			case "hx":
				return SCRIPT;
			case "as":
				return SCRIPT;
			case "mp3":
				return AUDIO;
			case "mat":
				return MATERIAL;
			default:
				return OTHERS;
		}
	}
}