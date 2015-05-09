package blendhx.editor.mvc;


import blendhx.engine.components.IComposite;
import blendhx.engine.assets.Assets;
import blendhx.engine.Viewport;
import blendhx.engine.Scene;
import blendhx.editor.helpers.IDragable;
import blendhx.editor.ui.FileItem;
import blendhx.editor.ui.HierarchyItem;
import blendhx.editor.ui.controls.ControlBase;

import blendhx.editor.presets.EditorCamera;
import blendhx.editor.presets.GridFloor;

import flash.events.IEventDispatcher;
import flash.filesystem.File;


interface IModel extends IEventDispatcher
{
	@:isVar public var entities(get, set):IComposite;
	@:isVar public var assets (get, set):Assets;
	@:isVar public var scene  (get, set):Scene;
	public var viewport :Viewport;

	public var playMode:Bool;
	public var savedEntities:IComposite;
	public var editModeSelectedEntity:IComposite;
	public var editorCamera:EditorCamera;
	public var gridFloor:IComposite;
	
	public var sourceDirectory   :File;
	public var casheDirectory    :File;
	@:isVar public var projectDirectory      (get, set):File;
	@:isVar public var currentAssetsDirectory(get, set):File;
	
	
	public var focusedControlBase:ControlBase;
	public var dragItem          :IDragable;
	public var lastSelectedObject:UInt; 
	public var selectedHierarchyItem : HierarchyItem;
	public var version           :String;
	@:isVar public var selectedEntity  (get, set):IComposite;
	@:isVar public var selectedFileItem(get, set):FileItem;


}