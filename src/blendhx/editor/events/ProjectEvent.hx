package blendhx.editor.events;

import blendhx.editor.ui.FileItem;

class ProjectEvent extends DisposableEvent
{
	public static inline var REQUEST_LOAD_PROJECT:String = "Request load project";
	public static inline var RELOAD_SCRIPTS:String = "Project reload scripts";
	public static inline var NEW   :String = "Project new";
	public static inline var OPEN  :String = "Project open";
	
	public static inline var SAVE :String = "Project save";
	public static inline var EXPORT_SWF  :String = "Project export swf";
	
	public static inline var PLAY_MODE:String = "Project play mode";
	public static inline var EDIT_MODE:String = "Project edit mode";
	
	public static inline var UNDO:String = "Project undo";
	public static inline var REDO:String = "Project redo";
	
	public static inline var HELP:String = "Project help";
}
