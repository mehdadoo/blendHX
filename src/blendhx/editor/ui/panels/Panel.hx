package blendhx.editor.ui.panels;

import blendhx.engine.components.IComponent;

import blendhx.editor.helpers.Utils;
import blendhx.editor.mvc.IView;
import blendhx.editor.mvc.UICompositeView;
import blendhx.editor.mvc.IModel;
import blendhx.editor.ui.UIComposite;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.controls.Checkbox;
import blendhx.editor.ui.ExtendedTextField;
import blendhx.editor.ui.RemoveButton;
import blendhx.editor.events.ComponentEvent;
import blendhx.editor.data.AS3DefinitionHelper;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;


class Panel extends UICompositeView
{
	public  var component      :IComponent;
	public  var checkBox       :ControlBase;
	public  var hasCheckbox    :Bool;
	public  var hasRemoveButton:Bool;
	public  var minimized      :Bool;
	
	@:isVar public var enabled(get, set):Bool;
	@:isVar public var title(get, set):String;
	
	private var handle         :Sprite;
	private var minimizeHotspot:Sprite;
	private var disabledGraphic:Sprite;
	private var removeButton   :RemoveButton;
	private var titleTextField :ExtendedTextField;
	
	
	public function new(title:String, _width:Float, hasCheckbox:Bool = false, hasRemoveButton:Bool = false) 
	{
		super();
		
		this.enabled         = true;
		this.title           = title;
		this._width          = _width;
		this.hasCheckbox     = hasCheckbox;
		this.hasRemoveButton = hasRemoveButton;
		this.disabledGraphic = new Sprite();
		
		
		initialize();
		
		createGraphics();
		resize();
	}	
	
	public function get_enabled():Bool
	{
		return enabled;
	}
	
	public function set_enabled(param:Bool):Bool
	{
		enabled = param;
		if( checkBox != null)
			checkBox.value = enabled;
		return param; 
	}
	
	public function get_title():String
	{
		return title;
	}
	public function set_title(param:String):String
	{
		title = param;
		if( titleTextField != null)
			titleTextField.text = title;
		return param; 
	}
	
	override public function update():Void{}
	private function initialize (){}
	private function updateModel(){}
	
	override public function addUIComponent(uiComponent:UIComponent)
	{
		super.addUIComponent( uiComponent );
		calcualteHeight();
	}
	
	override public function resize()
	{
		//create the top header if it is not the first panel in it's parent
		if(y>50)
			drawHeaderLine();
		
		if (removeButton != null)
			removeButton.x = _width - 30;
		
		calcualteHeight();
		drawDisabledGraphic();
		super.resize();
	}
	
	private function createGraphics()
	{
		createHandleGraphic  ();
		createMinimizeHotspot();
		createRemoveButton   ();
		createHeaderGraphic  ();
		
		drawDisabledGraphic  ();
	}
	
		
	private function createRemoveButton()
	{
		if( !hasRemoveButton )
			return;
		
		removeButton   = new RemoveButton(removeHostComponent);
		removeButton.x = _width - 30;
		removeButton.y = 7;
		
		addChild( removeButton );
	}
	
	private function createHandleGraphic()
	{
		handle = new Sprite();
		var g:Graphics = handle.graphics;
		
		g.beginFill(0x272727 );
		g.lineStyle(0 , 0 , 0);
		g.moveTo   (-4, -4);
		g.lineTo   (6 , -4);
		g.lineTo   (1 , 3 );
		g.lineTo   (-4, -4);
		g.endFill  ();
		
		handle.x = 16;
		handle.y = 16;
		
		addChild(handle);
	}

	private function createMinimizeHotspot()
	{
		minimizeHotspot = new Sprite();
		var g:Graphics = minimizeHotspot.graphics;
		
		g.lineStyle(0, 0, 0);
		g.beginFill(1, 0);
		g.drawRect (5, 7, _width - 10, 20);

		addChild(minimizeHotspot);
		minimizeHotspot.addEventListener(MouseEvent.CLICK, onHandleClick);
	}
	
	private function createHeaderGraphic()
	{
		var x = 26;
		
		if( hasCheckbox )
		{
			checkBox = new Checkbox("", 8,  onCheckboxChanged);
			checkBox.x = x;
			checkBox.value = true;
			addChild( checkBox );
			x = 45;
		}
		
		titleTextField = new ExtendedTextField(TextFormatAlign.LEFT, Utils.GetTitle(title) );
		titleTextField.autoSize = TextFieldAutoSize.LEFT;
		titleTextField.x = x;
		titleTextField.y = 6;
		addChild(titleTextField);
	}
	

	// on resize, this needs to be redrawn
	private function drawHeaderLine()
	{
		var g:Graphics = graphics;
		graphics.clear();
		
		g.lineStyle(    1    , 0x272727, 1);
		g.moveTo   (    10   , 0);
		g.lineTo   (_width-10, 0);
		g.lineStyle(    1    , 0x959595, 1);
		g.moveTo   (    10   , 1);
		g.lineTo   (_width-10, 1);
		
	}
	
	private function drawDisabledGraphic()
	{
		if( enabled == true )
		{
			if(contains(disabledGraphic))
				removeChild(disabledGraphic);
			return;
		}
		
		addChild(disabledGraphic); 
		
		var g:Graphics = disabledGraphic.graphics;
		g.clear();
		g.lineStyle(0, 0, 0);
		g.beginFill(0x727272, 0.5);
		g.drawRect(1, 30, _width-2 , _height - 30);
		g.endFill();
	}
	
	
	public function onCheckboxChanged()
	{
		enabled = checkBox.value;
		drawDisabledGraphic();
		
		var e:ComponentEvent = new ComponentEvent( ComponentEvent.ENABLE );
		e.component = component;
		
		dispatchEvent(e);
		//e.dispose();
		
	}
	
	private function removeHostComponent()
	{
		var e:ComponentEvent = new ComponentEvent( ComponentEvent.REMOVE );
		e.component = component;
		dispatchEvent(e);
		//e.dispose();
	}
	
	//minimize or maximize accordingl once clicked
	private function onHandleClick(e:MouseEvent)
	{
		if(!minimized)
		{
			minimized = true;
			handle.rotation = -90;
			minimize();
		}
		else 
		{
			minimized = false;
			handle.rotation = 0;
			maximize();
		}
		
		container.resize();
	}

	public function minimize()
	{
		for (uiComponent in uiComponents)
			removeChild(uiComponent);
	}
	
	public function maximize()
	{
		for (uiComponent in uiComponents)
			addChild(uiComponent);
	}

	public function calcualteHeight()
	{
		_height = 30;
		
		if ( uiComponents == null || uiComponents.length == 0 )
		{
			return;
		}

		if( !minimized )
		{
			var uiComponent = uiComponents[ uiComponents.length - 1 ];
			if (uiComponent.y + uiComponent._height + padding > _height)
				_height = uiComponent.y + uiComponent._height + padding;
		}
		
	}
}