package blendhx.editor.ui;


import blendhx.engine.Scene;
import blendhx.engine.components.IComposite;

import blendhx.editor.helpers.ObjectType;
import blendhx.editor.helpers.IDragable;
import blendhx.editor.mvc.IModel;
import blendhx.editor.mvc.UICompositeView;
import blendhx.editor.events.HierarchyEvent;
import blendhx.editor.ui.UIComponent;
import blendhx.editor.ui.ExtendedTextField;
import blendhx.editor.ui.contextMenu.EntityContextMenu;
import blendhx.editor.ui.contextMenu.ContextMenu;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.geom.Matrix;


class HierarchyItem extends UICompositeView implements IDragable
{
	public static var Images:BitmapData = new blendhx.editor.ui.embeds.Images.HierarchyImages(0, 0);
	
	public static var TRANSFORM:UInt = 0;
	public static var LAMP:UInt = 16;
	public static var MESH:UInt = 32;
	public static var CAMERA:UInt = 48;
	public static var SOUND:UInt = 64;
	
	private var label:ExtendedTextField;
	private var depth : UInt = 0;
	public  var entity:IComposite;
	
	private var type:UInt;
	private var icon:Sprite;
	private var collapseSprite:Sprite;
	
	public  var dragGraphic:BitmapData;
	public  var dragValue:Dynamic;
	public  var dragText :String="";
	public  var dragType  :UInt;

	
	public function new(model:IModel) 
	{
		super();

		this.model  = model;
		this.padding = 20;

		
		collapseSprite = new Sprite();
		icon = new Sprite();
		icon.mouseEnabled = false;
		
		

		this.addEventListener(MouseEvent.CLICK, select);
		this.addEventListener(MouseEvent.RIGHT_CLICK, rightClick);
		collapseSprite.addEventListener(MouseEvent.MOUSE_DOWN, onCollapseClick);
		
		addChild(icon);
		addChild(collapseSprite);
		
		createLabel();
	}
	
	override public function update()
	{
		recreateChildren();
		
		super.update();
	}
	
	public function initialize( entity:IComposite, depth:UInt = 0 )
	{
		this.entity = entity;
		this.depth  = depth;
		this.name   = entity.name;
		
		label.text = entity.name;
		
		dragText   = entity.name;
		dragValue  = entity;
		dragType   = ObjectType.ENTITY;
		
		if(model.selectedEntity == entity)
		{
			model.selectedHierarchyItem = this;
		}
		
		asignType();
	}
	
	public function setDragItem(dragItem:IDragable):Void
	{
		var hierarchyItem:HierarchyItem = cast dragItem;
		
		var e:HierarchyEvent = new HierarchyEvent(HierarchyEvent.SELECT);
		e.entity = hierarchyItem.entity;
		dispatchEvent(e);
		//e.dispose();
		
		e = new HierarchyEvent(HierarchyEvent.REPARENT);
		e.entity = entity;
		dispatchEvent(e);
		//e.dispose();
	}
	
	//create child hierarchy items
	private function recreateChildren() 
	{
		removeUIComponents();
		
		if(entity.collapseInHierarchy || !entity.enabled )
			return;
		
		for( child in entity.children )
		{
			var isIComposite:Bool = untyped __is__(child, IComposite) ;
			if( isIComposite )
			{
				var entity:IComposite = untyped __as__(child, IComposite);

				var hierarchyItem = HierarchyItemFactory.Create(model, entity, depth);
				addUIComponent( hierarchyItem );
			}
		}	
	}
	private function reverseAddChild()
	{
		//n is used for reverse aray iteration!
		var n:Int = uiComponents.length - 1;

		for (i in 0 ... uiComponents.length) 
		{
			addChild( uiComponents[n] );
			n--;
		}
		
	}

	override public function addUIComponent( uiComponent:UIComponent )
	{
		super.addUIComponent(uiComponent);
		
		reverseAddChild();
		
		this.addChild(icon );
		this.addChild(label);
		this.addChild(collapseSprite);
		
	}
	
	private function select(e:MouseEvent)
	{
		//if a child item is clicked let her dispatch her own event 
		if(e.target != this)
			return;
		
		// >>>>>>
		var e:HierarchyEvent = new HierarchyEvent( HierarchyEvent.SELECT);
		e.entity = entity;
		dispatchEvent( e );
		e.dispose();
	}
	
	private function rightClick(e:MouseEvent)
	{
		//if a child item is clicked let her dispatch her own event 
		if(e.target != this)
			return;
		
		// >>>>>>
		var event:HierarchyEvent = new HierarchyEvent( HierarchyEvent.SELECT );
		event.entity = entity;
		dispatchEvent( event );
		//event.dispose();
		
		var entityMenu:ContextMenu = new EntityContextMenu();
		entityMenu.display(e.stageX, e.stageY);
	}
	
	
	

	private function asignType()
	{
		var childClassName:String = Std.string( entity.children[1] );
		switch (  childClassName  )
		{
			case "[object Camera]":
				type = CAMERA;
			case "[object MeshRenderer]":
				type = MESH;
			case "[object Sound]":
				type = SOUND;
			case "[object Lamp]":
				type = LAMP;
			default:
				type = TRANSFORM;
		}
		
	}
	
	private function createLabel()
	{
		label = new ExtendedTextField( TextFormatAlign.LEFT, "entity");
		label.multiline = false;
		label.y = 2;
		label.height = 20;	
		label.mouseEnabled = false;
		
		addChild(label);
	}
	
	public function redraw()
	{
		redrawLines();
		redrawIcon();
		redrawCollapsedGraphic();
		
		redrawSelectedGraphic();
		redrawDragGraphic();
	}

	private function redrawLines()
	{
		var g:Graphics = graphics;
		g.clear();
		
		if ( !untyped __is__(container, HierarchyItem) )
			return;

		g.lineStyle(1, 0x444444, 1);
		g.moveTo(label.x, padding/2);
		g.lineTo(label.x - padding , padding/2);
		g.lineTo(label.x - padding, - container._height + padding/2);
	}

	private function redrawIcon()
	{
		var g:Graphics;
		var matrix:Matrix = new Matrix();
  		matrix.translate(-type, padding/2);
		
		g = icon.graphics;
		g.clear();
		g.beginBitmapFill( HierarchyItem.Images, matrix);
		g.drawRect(0, padding/2, 16, 16);
		g.endFill();
		icon.x = label.x - 8;
		icon.y = 4 - padding/2;
		label.x += 9;
	}

		
	private function redrawCollapsedGraphic()
	{
		var childEntities:UInt = 0;
		
		var g:Graphics = collapseSprite.graphics;
		g.clear();
			
		if( entity.parent == null )
			return;
		
		if( untyped __is__(entity.parent, Scene) )
			return;
		
		for(child in entity.children)
		{
			var isEntity:Bool = untyped __is__(child, IComposite);
			if ( isEntity )
				childEntities++;
		}
		
		
		if(childEntities == 0)
			return;
		
		//draw collapse thing
		var g:Graphics = collapseSprite.graphics;
		collapseSprite.x = label.x - padding - 9;
		collapseSprite.y = padding/2;
		g.clear();
		
		g.beginFill(0xd4d4d4, 1);
		g.lineStyle(1, 0x222222, 1);
		g.drawCircle(.5 , .5, 4);
		g.endFill();
		
		g.lineStyle(1, 0x111111, 1);
		
		g.moveTo(-2, 0);
		g.lineTo(3, 0);
		
		if ( entity.collapseInHierarchy == true)
		{
			g.moveTo(0, -2);
			g.lineTo(0, 3);
		}	
	}
		
	private function onCollapseClick(_)
	{
		entity.collapseInHierarchy = !entity.collapseInHierarchy;
	}

	private function redrawDragGraphic()
	{
		if(dragGraphic == null)
			dragGraphic = new BitmapData(200, 20, true,0x00FFFFFF);
		
		var matrix:Matrix = new Matrix();
		dragGraphic.unlock();
		dragGraphic.fillRect(dragGraphic.rect, 0x00000000);
		matrix.translate(padding/2, - padding/2);
		dragGraphic.draw(icon, matrix);
		matrix.translate(padding/2 + 8, padding/2);
		dragGraphic.draw(label, matrix);
		dragGraphic.lock();
	}

	private function redrawSelectedGraphic()
	{
		if(model.selectedEntity == entity)
		{
			label.textColor = 0xffffff;
			var g:Graphics = graphics;
			g.beginFill(0xec8e2a, .5);
			g.lineStyle(0, 0, 0);
			g.drawCircle(label.x - 9, padding/2 + 2, 9);
			g.endFill();
		}
		else
		{
			label.textColor = 0x000000;
		}
	}

	override public function resize()
	{
		_height = padding;
		
		for (uiComponent in uiComponents)
		{
			uiComponent._width = _width;
			uiComponent.resize();
			_height += uiComponent._height;
		}
		
		label.x     = padding + (depth * padding);
		label.width = _width - label.x - padding;

		repositionUIComponentsVertically();

		redraw();
	}

		
	private function repositionUIComponentsVertically()
	{
		if (uiComponents.length >= 1)
			uiComponents[0].y = padding;

		if (uiComponents.length > 1)
		{
			for (i in 1...uiComponents.length)
			{
				uiComponents[i].y = uiComponents[i-1]._height + uiComponents[i-1].y;
			}
		}
	}
	
				
	override public function dispose()
	{
		dragText  = null;
		dragValue = null;
		entity    = null;
		super.dispose();
	}
}