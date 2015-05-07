package blendhx.editor.ui;
import blendhx.editor.helpers.Utils;

import blendhx.editor.helpers.IDragable;
import blendhx.editor.ui.contextMenu.ContextMenu;
import blendhx.editor.ui.contextMenu.FileItemContextMenu;
import blendhx.editor.helpers.ObjectType;
import blendhx.editor.ui.ExtendedTextField;
import blendhx.editor.events.AssetsEvent;
import blendhx.editor.ui.embeds.Images;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormatAlign;
import flash.geom.Matrix;
import flash.filesystem.File;


class FileItem extends UIComposite implements IDragable
{
	
	public  static var colomnWidth:Float = 300;
	public  static var Images:BitmapData = new blendhx.editor.ui.embeds.Images.FileImages(0, 0);
	
	public  var file     :File;
	private var icon     :Sprite;
	private var label    :ExtendedTextField;
	private var highlight:Sprite;
	
	public  var sourceURL:String = "";
	public  var type    :UInt;
	
	@:isVar public var selected(get, set):Bool;
	
	//highlight states
	private var selectedState:UInt = 0xdd8335;
	private var mouseOver    :UInt = 0xffffff;
	private var clear        :UInt = 0;
	
	//IDragable implementation
	public  var dragGraphic:BitmapData;
	public  var dragValue:Dynamic;
	public  var dragText :String="";
	public  var dragType  :UInt;
	
	public function new() 
	{
		super();
		
		icon          = new Sprite();
		highlight     = new Sprite();
		mouseChildren = false;
		
		addChild(highlight);
		addChild(icon);
		createLabel();
		
		addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
		addEventListener(MouseEvent.CLICK      , onClick     );
		addEventListener(MouseEvent.MOUSE_OVER , onMouseOver );
		addEventListener(MouseEvent.MOUSE_OUT  , onMouseOut  );
	}
	
	public function initialize( file:File=null, sourceURL:String="") 
	{
		var extension:String = "";
		
		this.selected  = false;
		this.file     = file;
		this.sourceURL = sourceURL;
		
		if(file == null)
		{
			label.text = "...";
			extension  = "back";
		}
		else
		{
			label.text = file.name;
			extension  = file.extension;
		}
			
		if(extension == null)
			extension = "";
		
		type = ObjectType.GetType( extension );
		
		dragText  = label.text;
		dragType  = type;
		
		dragValue = sourceURL;
			
		redraw();

		mark( clear );
	}
	
	public function setDragItem(dragItem:IDragable):Void
	{
		trace( dragItem );
	}
	
	private function createLabel():Void
	{
		label = new ExtendedTextField(TextFormatAlign.LEFT);
		label.height = 20;
		label.width = colomnWidth - 30;
		label.x = 18;
		label.embedFonts = true;
		label.textColor = 0xffffff;
		
		addChild(label);
	}
	
	public function get_selected():Bool{return selected;}
	public function set_selected(param:Bool):Bool
	{
		selected = param; 
		
		if(!selected)
			mark( clear );
		else
			mark( selectedState );
			
		return param;
	}
	
	
	private function onRightClick(e:MouseEvent)
	{	
		if(type == ObjectType.BACK )
			return;
		
		select();
		
		var menu:ContextMenu = new FileItemContextMenu( this );
		menu.display(e.stageX, e.stageY);
	}
	
	private function onClick(_)
	{	
		if(type == ObjectType.BACK || type == ObjectType.FOLDER)
		{
			open();
		}
		else
		{
			select();
		}
	}
	
	private function select()
	{	
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.SELECT);
		e.fileItem = this;
		dispatchEvent( e );
		e.dispose();
	}
	
	private function open()
	{	
		var e:AssetsEvent = new AssetsEvent(AssetsEvent.OPEN);
		e.fileItem = this;
		dispatchEvent( e );
		e.dispose();
	}
	
	
	
	private function onMouseOver(_):Void
	{
		if(  selected )
			return;
		
		mark( mouseOver );
	}
	
	private function onMouseOut(_):Void
	{
		if(  !selected  )
			mark( clear );
	}
	
	private function mark(state:UInt):Void
	{
		var _alpha:Float = 0.8;
		
		if(state == mouseOver)
			_alpha = 0.1;
		
		var g:Graphics = highlight.graphics;
		g.clear();
		
		if(state == clear)
			return;
			
		g.beginFill(state, _alpha);
		g.drawRoundRect(-2, 1, colomnWidth - 12, 18, 10);
		g.endFill();
	}
	
	
	private function redraw()
	{
		var g:Graphics = icon.graphics;
		g.clear();
		
		var matrix:Matrix = new Matrix();
  		matrix.translate(1 , 2 + (16 - type) * 16);
		
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(FileItem.Images, matrix);
		g.drawRect (1, 2, 16, 16);
		g.endFill  ();
		
		redrawDragGraphic();
	}
	
	private function redrawDragGraphic()
	{
		if(dragGraphic == null)
			dragGraphic = new BitmapData(200, 20, true,0x00FFFFFF);
		
		dragGraphic.fillRect(dragGraphic.rect, 0x00000000);
		dragGraphic.draw(this);
	}
}