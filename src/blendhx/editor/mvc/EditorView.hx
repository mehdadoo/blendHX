package blendhx.editor.mvc;


import blendhx.engine.Viewport;

import blendhx.editor.mvc.UICompositeView;
import blendhx.editor.mvc.IModel;
import blendhx.editor.ui.spaces.*;


import flash.Lib;

class EditorView extends UICompositeView
{
	private var viewport  :Viewport;
	
	private var properties :UICompositeView;
	private var hierarchy  :UICompositeView;
	private var console    :UICompositeView;
	private var assets     :UICompositeView;
	private var menu       :UICompositeView;
	
	public function new(model:IModel, viewport:Viewport) 
	{
		super();
		
		this.model      = model;
		model.viewport  = viewport;
		this.viewport   = viewport;

		createDefaultSpaces();
	}
	
	private function createDefaultSpaces():Void
	{
		hierarchy  = new HierarchySpace ( model, 200);
		properties = new PropertiesSpace( model, 250);
		console    = new ConsoleSpace   ( );
		assets     = new AssetsSpace    ( model);
		menu       = new MenuSpace      ( model);

		addUIComponent(hierarchy  );
		addUIComponent(properties );
		addUIComponent(console    );
		addUIComponent(assets     );
		addUIComponent(menu       );
	}
	
	override public function resize()
	{
		_height = Lib.current.stage.stageHeight-1;
		_width  = Lib.current.stage.stageWidth-1;
		
		menu._width = _width;
		menu._height = 25;
		
		console._height = 175;
		console._width = _width / 2;
		console.y = _height - console._height; 
		
		assets._height  = 175;
		assets._width = _width / 2;
		assets.x = _width / 2;
		assets.y = _height - assets._height; 
		
		properties.y = menu._height ;
		properties.x = _width - properties._width;
		properties._height = _height - console._height - menu._height ;
		
		hierarchy.y  = menu._height ;
		hierarchy._height  = _height - console._height - menu._height;

		viewport.width = _width - hierarchy._width - properties._width;
		viewport.height = _height - console._height - menu._height;
		viewport.x = hierarchy._width;
		viewport.y = menu._height;
		
		super.resize();
	}
}