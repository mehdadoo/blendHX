package blendhx.editor.events;

import blendhx.editor.ui.FileItem;

class AssetsEvent extends DisposableEvent
{
	public static inline var OPEN:String = "Asset Open";
	public static inline var SELECT:String = "Asset Select";
	public static inline var DELETE:String = "Asset delete";
	public static inline var RENAME:String = "Asset rename";
	public static inline var RENAME_REQUEST:String= "Asset rename request";
	
	public static inline var CREATE_NEW_FOLDER  :String = "Assets create new folder";
	public static inline var CREATE_MATERIAL    :String = "Assets create material";
	public static inline var CREATE_SHADER      :String = "Assets create shader";
	public static inline var CREATE_HAXE_FILE :String = "Assets create haxe file";
	public static inline var CREATE_ACTIONSCRIPT:String = "Assets create actionscript file";
	
	public static inline var IMPORT_MESH   :String = "Assets import mesh";
	public static inline var IMPORT_TEXTURE:String = "Assets import texture";
	

	public var fileItem:FileItem;
	public var fileName:String;
	
	override public function dispose()
	{
		fileItem = null;
		super.dispose();
	}
}