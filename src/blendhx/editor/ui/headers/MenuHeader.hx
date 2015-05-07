package blendhx.editor.ui.headers;


import blendhx.editor.mvc.IModel;

import blendhx.editor.events.ProjectEvent;
import blendhx.editor.ui.Progressbar;
import blendhx.editor.ui.controls.ImageButton;
import blendhx.editor.ui.controls.HeaderButton;
import blendhx.editor.ui.controls.Label;
import blendhx.editor.ui.controls.ControlBase;
import blendhx.editor.ui.contextMenu.ContextMenu;
import blendhx.editor.ui.contextMenu.FileMenuContextMenu;
import blendhx.editor.ui.contextMenu.EditMenuContextMenu;
import blendhx.editor.ui.contextMenu.HelpMenuContextMenu;

import flash.display.BitmapData;
import flash.display.Bitmap;

class MenuHeader extends Header
{
	private var progressBar:UIComponent;
	private var info       :UIComposite;
	
	private var reload:ControlBase;
	private var play  :ControlBase;
	private var stop  :ControlBase;
		
	public function new(model:IModel) 
	{
		super( model );
		
		
		progressBar = Progressbar.getInstance();
		info = new UIComposite();
		
		
		
		var appIcon:BitmapData = new blendhx.editor.ui.embeds.Images.AppIcon(0, 0);
		info.addChild( new Bitmap( appIcon ) ).y = 5;
		
		var label = new Label("   " + model.version, 3, null, info);
		info._width = label.width + 13;
		
		
		new HeaderButton("File", 3, openFileMenu, this)._width = 50;
		new HeaderButton("Edit", 3, openEditMenu, this)._width = 50;
		new HeaderButton("Help", 3, openHelpMenu, this)._width = 50;
		
		play = new ImageButton("", 3, playMode, this, ControlBase.FIXED_WIDTH, 1, ControlBase.ROUND_LEFT, ImageButton.PLAY);
		stop = new ImageButton("", 3, editMode, this, ControlBase.FIXED_WIDTH, 1, ControlBase.ROUND_NONE, ImageButton.STOP);
		reload = new ImageButton("", 3, reloadScripts, this, ControlBase.FIXED_WIDTH, 1, ControlBase.ROUND_RIGHT, ImageButton.REFRESH);
		
		
		addUIComponent(info);
		addUIComponent(progressBar);
		
		
	}
	
	private function playMode()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.PLAY_MODE);
		dispatchEvent( e );
		e.dispose();
	}
	
	private function editMode()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.EDIT_MODE);
		dispatchEvent( e );
		e.dispose();
	}
	
	private function reloadScripts()
	{
		var e:ProjectEvent = new ProjectEvent(ProjectEvent.RELOAD_SCRIPTS);
		dispatchEvent( e );
		e.dispose();
	}
	
	private function openFileMenu()
	{
		var menu:ContextMenu = new FileMenuContextMenu();
		menu.display(5, 25);
	}
	
	private function openEditMenu()
	{
		var menu:ContextMenu = new EditMenuContextMenu();
		menu.display(60, 25);
	}

	private function openHelpMenu()
	{
		var menu:ContextMenu = new HelpMenuContextMenu();
		menu.display(115, 25);
	}

	override public function resize()
	{
		super.resize();
		
		play.enabled = !model.playMode;
		stop.enabled = model.playMode;
		
		progressBar.x = _width - progressBar._width + 2 - padding;
		info.x = progressBar.x - info._width;
		
		play._width = 22;
		stop._width = 18;
		reload._width = 22;
		
		play.x = _width/2 - 25;
		stop.x = _width/2;
		reload.x = _width/2 + 23;
		
		play.resize();
		stop.resize();
	}
	
	override public function redraw(){}
}